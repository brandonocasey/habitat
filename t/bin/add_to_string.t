#! /bin/sh

func="$1"
in_path="hello"
assert_raises "$func '-h'" "2"
assert_raises "$func '--h'" "2"
assert_raises "$func '--help'" "2"
assert_raises "$func '-help'" "2"
assert_raises "$func ''" "2"
assert_raises "$func '' ''" "2"
assert_raises "$func '' '' ''" "2"
assert_raises "$func '' 'asd' ''" "2"
assert_raises "$func '' '' 'asd'" "2"

assert_raises "$func 'hello' 'hello' ','" "1"
assert "$func '$in_path' 'hello' ','" "hello"

assert_raises "$func 'hello' 'bats' ','" "0"
assert "$func '$in_path' 'bats' ','" "hello,bats"

assert_raises "$func 'hello,bats' 'hello' ':'" "0"
assert "$func 'hello,bats' 'hello' ':'" "hello,bats:hello"

