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
function get() {
  local config="$1"; shift
  local key="$1"; shift
  local key_found="1"
  local quotes_found="0"
  local line
  if [ -z "$key" ]; then
    echo "Key is required for get"
    exit 3
  fi
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

# validate that the config is valid
function validate() {
  # make sure the config is valid
  local config="$1"; shift

  local key_found="1"
  local quotes_found="0"
  local current_key=""
  local current_value=""

  while read line; do
    line="$(remove_comments "$line")"
    if [ -n "$line" ]; then
      if [ -z "$(echo "$line" | grep '^.*=.*')" ]; then
        echo "Cannot have a key that has no value"
        exit 3
      fi
      if [ -n "$(echo "$line" | grep '^.*=')" ]; then
        local new_key="$(echo "$line" | sed -e 's~=.*$~~')"
        if [ -z "$current_key" ]; then
          current_key="$new_key"
        else
          echo "Another key '$new_key' was found before old key '$current_key' ended"
          exit 3
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
          exit 3
        fi
        quotes_found="0"
        current_key=""
        current_value=""
      elif [ "$quotes_found" -gt "2" ]; then
        echo "To many quotes following $current_key"
        exit 3
      fi
    fi
  done < "$config"

  for i in $(getkeys "$config"); do
    match="0"
    for z in $(getkeys "$config"); do
      if [ -n "$( echo "$i" | grep "$z")" ]; then
        match=$((match+1))
      fi
    done

    if [ "$match" -gt "1" ]; then
      echo "key $i is in the config $match times"
      exit 3
    fi
  done

  if [ -n "$current_key" ] && [ "$quotes_found" -lt "2" ]; then
    echo "Not enough quotes for the last key $current_key"
    exit 3
  fi
}

function getkeys() {
  local config="$1"; shift
  while read -r line; do
    line="$(remove_comments "$line")"
    if [ -n "$( echo "$line" | grep '^.*=')" ]; then
      echo "$line" | sed -e 's~=.*$~~'
    fi

  done < "$config"


}

function upsert() {
  local config="$1"; shift
  local key="$1"; shift
  local new_value="$1"; shift

  if [ -z "$new_value" ]; then
    echo "Cannot Set config $key with a blank value"
    exit 3
  fi
  if [ -z "$key" ]; then
    echo "Key cannot be blank"
    exit 3
  fi

  local old_value="$(get "$config" "$key")"

  # if we have  value we know its in the config file
  if [ -n "$old_value" ]; then
    local new_config="$(cat "$config" | sed -e "s~$key=\".*\"~$key=\"$new_value\"~")"
  else
    local new_config="$(cat "$config")"
    new_config+="\n$(echo "$key=\"$new_value\"")"
  fi

  printf "$new_config\n" > "$config"
}

function delete() {
  local config="$1"; shift
  local key="$1"; shift

  if [ -z "$key" ]; then
    echo "Key is required for delete"
    exit 3
  fi

  if [ -z "$(get "$config" "$key")" ]; then
    echo "Cannot remove $key as it is not in the config file"
    exit 1
  fi

  local new_config=""
  local line
  local skip="1"
  while read line; do
    if [ -n "$( echo "$line" | grep "^$key=")" ]; then
      line="$(echo "$line" | sed -e "s~^$key=\".*\"[[:space:]]*~~")"
      if [ -z "$line" ]; then
        skip="0"
      fi
    fi
    if [ "$skip" -eq "1" ]; then
      new_config+="$line\n"
    else
      skip="1"
    fi
  done < "$config"
  if [ -n "$new_config" ]; then
    printf "$new_config\n" > "$config"
  else
    : > "$config"

  fi
}


function usage() {
    echo
    echo "    ./$(basename "$0") <config> --<action> <args>"
    echo
    echo '    Info:'
    echo '    Remove, Upsert, Get, or Get all settings from a config file'
    echo '    Config files can have comments, but config keys cannot be empty string'
    echo
    echo '    Example:'
    echo '    thing="55"'
    echo '    example="55"'
    echo
    echo '    Return Codes:'
    echo '    0 = Success'
    echo '    1 = Error'
    echo '    2 = Argument Passing Error'
    echo '    3 = Validation Error'
    echo
    echo '    Arguments'
    echo '    <config>                 The Location of the config to read (will be created if needed)'
    echo '    --upsert <key> <value>   Insert/update a new/existing key, value pair'
    echo '    --delete <key>           Remove a key from the config entirly'
    echo '    --get <key>              Get the value of a key if it exists, or empty string'
    echo '    --getkeys                Get all the keys in the config (good for use with get)'
    echo '    --validate               Validate the config file (done automatically every other action)'
    echo
    exit 2
}

if [ -z "$1" ] || [ -z "$2" ] || [ "$#" -gt "4" ]; then
  usage
fi
config="$1"; shift
if [ ! -f "$config" ]; then
  touch "$config"
fi

while [ "$#" -gt "0" ]; do
  arg="$1"; shift
    if [ -n "$(echo "$arg" | grep -E '^--?(h|help)$')" ]; then
      usage
    elif [ -n "$(echo "$arg" | grep -E '^--?(upsert)$')" ]; then
      validate "$config"
      key="$1"; shift
      value="$1"; shift
      upsert "$config" "$key" "$value"
    elif [ -n "$(echo "$arg" | grep -E '^--?(delete)$')" ]; then
      validate "$config"
      key="$1"; shift
      delete "$config" "$key"
    elif [ -n "$(echo "$arg" | grep -E '^--?(get)$')" ]; then
      validate "$config"
      key="$1"; shift
      get "$config" "$key"
    elif [ -n "$(echo "$arg" | grep -E '^--?(getkeys)$')" ]; then
      validate "$config"
      getkeys "$config"
    elif [ -n "$(echo "$arg" | grep -E '^--?(validate)$')" ]; then
      validate "$config"
    else
      echo "Invalid option $arg"
      usage
    fi
done

exit 0
