#! /bin/sh

# TODO:
# * support single quotes
# * support quotes inside quotes if escaped
# * speed?

function remove_comments() {
  line="$1"; shift
  echo "$line" | sed -e 's~^ *#.*~~' | sed -e 's~"[[:space:]]*#.*$~"~'
}

# Find a specific key
function find_key_value() {
  local config="$1"; shift
  local key="$1"; shift
  local key_found="1"
  local quotes_found="0"
  local line
  while read line; do
    # remove comments
    line="$(remove_comments "$line")"

    # find the key
    if [ -n "$(echo "$line"| grep "$key=")"  ]; then
      line="$(echo "$line" | sed -e "s~$key=~~")"
      key_found="0"
    fi

    # look for the value
    if [ "$key_found" -eq "0" ] && [ "$quotes_found" -lt "2" ]; then
      while [ -n "$(echo "$line" | grep '"')" ]; do
        line="$(echo "$line" | sed -e 's~"~~')"
        quotes_found=$((quotes_found+1))
      done

      if [ -n "$line" ]; then
        echo "$line"
      fi
    fi
  done < "$config"
}

# Verify that the config is valid
function verify_config() {
  # make sure the config is valid
  local config="$1"; shift

  local key_found="1"
  local quotes_found="0"
  local current_key=""
  local current_value=""
  while read line; do
    line="$(remove_comments "$line")"
    if [ -n "$line" ]; then
      if [ -n "$( echo "$line" | grep '^.*=')" ]; then
        local new_key="$(echo "$line" | sed -e 's~=.*$~~')"
        if [ -z "$current_key" ]; then
          current_key="$new_key"
        else
          echo "Another key '$new_key' was found before old key '$current_key' ended"
          exit 1
        fi
        line="$(echo "$line" | sed -e "s~$current_key=~~")"
      fi
      if [ -n "$current_key" ] && [ "$quotes_found" -lt "2" ]; then
        line="$(echo "$line" | sed -e 's~\\"~~')"
        while [ -n "$(echo "$line" | grep '"')" ]; do
          line="$(echo "$line" | sed -e 's~"~~')"
          quotes_found=$((quotes_found+1))
        done
      fi


      if [ -n "$line" ]; then
        current_value+="$line"
      fi

      if [ "$quotes_found" -eq "2" ]; then
        if [ -z "$current_value" ]; then
          echo "key $current_key does not have a value"
          exit 1
        fi
        quotes_found="0"
        current_key=""
        current_value=""
      elif [ "$quotes_found" -gt "2" ]; then
        echo "To many quotes following $current_key"
        exit 1
      fi
    fi


  done < "$config"

  if [ -n "$current_key" ] && [ "$quotes_found" -lt "2" ]; then
    echo "Not enough quotes for the last key $current_key"
    exit 1
  fi
}

function find_all_keys() {
  local config="$1"; shift
  while read line; do
    line="$(remove_comments "$line")"
    if [ -n "$( echo "$line" | grep '^.*=')" ]; then
      echo "$line" | sed -e 's~=.*$~~'
    fi

  done < "$config"


}

function set_config_value() {
  local config="$1"; shift
  local key="$1"; shift
  local new_value="$1"; shift

  if [ -z "$new_value" ]; then
    echo "Cannot Set config $key with a blank value"
    exit 1;
  fi

  local value="$(find_key_value "$config" "$key")"

  # if we have  value we know its in the config file
  if [ -n "$value" ]; then
    echo "seding in new value $value"
    local new_config="$(cat "$config" | sed -e "s~$key=\"$value\"~$key=\"$new_value\"~")"
  else
    local new_config="$(cat "$config")"
    new_config+="\n$(echo "$key=\"$new_value\"")"
  fi

  printf "$new_config" > "$config"
}

function remove_key() {
  local config="$1"; shift
  local key="$1"; shift

  if [ -z "$(find_key_value "$config" "$key")" ]; then
    echo "Cannot remove $key as it is not in the config file"
    exit 1
  fi

  local new_config=""
  local line
  local skip="1"
  while read line; do
    if [ -n "$( echo "$line" | grep "$key=")" ]; then
      line="$(echo "$line" | sed -e 's~.*=".*"[[:space:]]*~~')"
      if [ -z "$line" ]; then
        skip="0"
      fi
    fi
    if [ "$skip" -eq "0" ]; then
      new_config+="$line"
    else
      skip="1"
    fi
  done < "$config"
  echo "$new_config" > "$config"
}


key="extensions"
quotes_found="0"

printf '# extensions=
        # extensions=
extensions="things/things#1.1.0 derp/derp#1.0.0 last/pass#0.0.0"# comments

other="11235"

batmans="bsd"
things="dasd"' > "$1"

verify_config "$1"
find_key_value "$1" "extensions"
find_key_value "$1" "other"
find_key_value "$1" "batmans"
find_key_value "$1" "things"

echo
echo "----all Keys----"
find_all_keys "$1"

rand="$RANDOM"
echo "----Setting key other to $rand----"
set_config_value "$1" "other" "$rand"
find_key_value "$1" "other"

echo "Real Config"
printf "$(cat "$1")\n"

echo '----Setting Lerp----'
set_config_value "$1" "lerp" "$RANDOM"
find_key_value "$1" "lerp"

echo "Real Config"
printf "$(cat "$1")\n"

echo '----Setting Again----'
set_config_value "$1" "lerp" "$RANDOM"
find_key_value "$1" "lerp"

echo "Real Config"
printf "$(cat "$1")\n"


echo '----Remove Lerp----'
remove_key "$1" "lerp"

echo "Real Config"
printf "$(cat "$1")\n"
