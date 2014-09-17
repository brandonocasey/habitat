#! /bin/sh

script_file="$1"
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
