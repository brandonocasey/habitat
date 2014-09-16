#! /bin/sh

script_name="$1"

assert_raises "$script_name '' ''" "2"
assert_raises "$script_name ''" "2"
assert_raises "$script_name " "2"
assert_raises "$script_name 'asd' ''" "2"
assert_raises "$script_name '' 'asd'" "2"


stub 'find'
assert_raises "source $script_name 'asd' 'asd'" "1"
restore 'find'


stub_and_eval 'find' 'echo "things"; echo "pings"; echo "cows"'
assert_raises "source $script_name 'thing' 'thing'" "0"
assert "source $script_name 'thing' 'thing'" "things
pings
cows"
restore 'find'

stub_and_eval 'find' 'echo "things"; echo "pings"; echo "cows"'
assert_raises "source $script_name 'asd' 'asd' 'things'" "0"
assert "source $script_name 'asd' 'asd' 'things'" "pings
cows"
restore 'find'

stub_and_eval 'find' 'echo "things"; echo "pings"; echo "cows"'
assert_raises "source $script_name 'asd' 'asd' 'things' 'pings' 'cows'" "1"
assert "source $script_name 'asd' 'asd' 'things' 'pings' 'cows'" ""
restore 'find'
