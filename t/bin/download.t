#!/bin/sh

script_file="$1"

assert_raises "$script_file ''" "2"
assert_raises "$script_file '' ''" "2"
assert_raises "$script_file '' 'asd' " "2"
assert_raises "$script_file 'asd' '' " "2"

stub_and_eval command 'return 1'
assert_raises "source $script_file 'things' 'place'" "2"
restore 'command'

stub_and_eval wget 'return 22'
assert_raises "source $script_file 'things' 'place'" "22"
restore 'wget'

stub_and_eval command 'if [ "$2" = "curl" ]; then return 0; fi'
stub_and_eval curl 'return 22'
assert_raises "source $script_file 'things' 'place'" "22"
restore 'wget'
