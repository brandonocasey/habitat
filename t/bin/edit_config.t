#! /bin/sh

script_file="$1"

test_config="$test_tmp_dir/test_config.cfg"
assert_raises "$script_file ''" "2"
assert_raises "$script_file '' ''" "2"
assert_raises "$script_file '' '' '' '' ''" "2"
assert_raises "$script_file '/tmp/thing' '-bom' 'nope'" "2"


function example_config() {
	printf \
'# extensions=
# extensions=
extensions="things/things#1.1.0 derp/derp#1.0.0 last/pass#0.0.0"# comments

other="11235"

batmans="bsd"
things="dasd"' > "$test_config"
}

function empty_config() {
	printf "" > "$test_config"
}

function add_one_key() {
	echo "$1=\"$2\"" >> "$test_config"
}

function cleanup() {
	assert_raises "test -f '$test_config'" "0"
	rm "$test_config"
}

# getkeys
example_config
assert_raises "$script_file '$test_config' --getkeys" "0"
assert "$script_file '$test_config' --getkeys" \
"extensions
other
batmans"
cleanup

empty_config
assert_raises "$script_file '$test_config' --getkeys" "0"
assert "$script_file '$test_config' --getkeys" ""
cleanup

add_one_key "one" "one"
assert_raises "$script_file '$test_config' --getkeys" "0"
assert "$script_file '$test_config' --getkeys" "one"
cleanup

add_one_key "one" "one"
add_one_key "two" "two"
assert_raises "$script_file '$test_config' --getkeys" "0"
assert "$script_file '$test_config' --getkeys" "one
two"
cleanup

# Get
example_config

assert_raises "$script_file '$test_config' --get 'extensions'" "0"
assert "$script_file '$test_config' --get 'extensions'" "things/things#1.1.0 derp/derp#1.0.0 last/pass#0.0.0"

assert_raises "$script_file '$test_config' --get 'batmans'" "0"
assert "$script_file '$test_config' --get 'batmans'" "bsd"

assert_raises "$script_file '$test_config' --get 'noexist'" "0"
assert "$script_file '$test_config' --get 'noexist'" ""

cleanup


assert_raises "$script_file '$test_config' --get ''" "3"


# Upsert
add_one_key "one" "one"
assert_raises "$script_file '$test_config' --upsert 'one' 'five'" "0"
assert "cat '$test_config'" 'one="five"'

assert_raises "$script_file '$test_config' --upsert 'batmans' 'ten'" "0"
assert "cat '$test_config'" 'one="five"
batmans="ten"'

assert_raises "$script_file '$test_config' --upsert 'batmans' '11'" "0"
assert "cat '$test_config'" 'one="five"
batmans="11"'
cleanup

assert_raises "$script_file '$test_config' --upsert 'batmans' " "3"
assert_raises "$script_file '$test_config' --upsert '' '' " "3"
assert_raises "$script_file '$test_config' --upsert 'asd' '' " "3"
assert_raises "$script_file '$test_config' --upsert '' 'asd' " "3"
cleanup


# Delete
add_one_key "one" "one"
assert_raises "$script_file '$test_config' --delete 'one'" "0"
assert "cat '$test_config'" ''
cleanup

add_one_key "ten" "ten"
add_one_key "one" "one"
assert_raises "$script_file '$test_config' --delete 'one'" "0"
assert "cat '$test_config'" 'ten="ten"'
cleanup

add_one_key "ten" "ten"
add_one_key "one" "one"
add_one_key "five" "five"
add_one_key "four" "four"
assert_raises "$script_file '$test_config' --delete 'five'" "0"
assert "cat '$test_config'" 'ten="ten"
one="one"
four="four"'
cleanup

add_one_key "ten" "ten"
add_one_key "one" "one"
add_one_key "five" "five"
add_one_key "four" "four"
add_one_key "six" "six"
add_one_key "nine" "nine"
assert_raises "$script_file '$test_config' --delete 'nine'" "0"
assert "cat '$test_config'" 'ten="ten"
one="one"
five="five"
four="four"
six="six"'
cleanup

add_one_key "ten" "ten"
add_one_key "one" "one"
add_one_key "five" "five"
add_one_key "four" "four"
add_one_key "six" "six"
add_one_key "nine" "nine"
assert_raises "$script_file '$test_config' --delete 'ten'" "0"
assert "cat '$test_config'" 'one="one"
five="five"
four="four"
six="six"
nine="nine"'
cleanup

assert_raises "$script_file '$test_config' --delete ''" "3"
cleanup

# Validate
assert_raises "$script_file '$test_config' --validate" "0"
assert "cat '$test_config'" ""
cleanup

echo "# nope=\""> "$test_config"
assert_raises "$script_file '$test_config' --validate" "0"
cleanup


echo "nope" > "$test_config"
assert_raises "$script_file '$test_config' --validate" "3"
cleanup

echo "nope=" > "$test_config"
assert_raises "$script_file '$test_config' --validate" "3"
cleanup


echo "nope=\"" > "$test_config"
assert_raises "$script_file '$test_config' --validate" "3"
cleanup

echo "nope=\"\"" > "$test_config"
assert_raises "$script_file '$test_config' --validate" "3"
cleanup

echo "nope=\"asd\"" > "$test_config"
echo "nope=\"derp\"" >> "$test_config"
assert_raises "$script_file '$test_config' --validate" "3"
cleanup



