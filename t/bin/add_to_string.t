#!/bin/sh

script_file="$1"

assert_raises "$script_file ''" "2"
assert_raises "$script_file '' ''" "2"
assert_raises "$script_file '' '' ''" "2"
assert_raises "$script_file '' 'asd' ''" "2"
assert_raises "$script_file '' '' 'asd'" "2"

assert_raises "$script_file 'hello' 'hello' ','" "1"
assert "$script_file 'hello' 'hello' ','" "hello"

assert_raises "$script_file 'hello' 'bats' ','" "0"
assert "$script_file 'hello' 'bats' ','" "hello,bats"

assert_raises "$script_file 'hello,bats' 'hello' ':'" "0"
assert "$script_file 'hello,bats' 'hello' ':'" "hello,bats:hello"

