#! /usr/bin/env bash

func="regex_match"
assert_raises "$func 'bash' 'bash'" "0"
assert_raises "$func 'bash' '^bash$'" "0"
assert_raises "$func 'space space space' 'space space space'" "0"
assert_raises "$func 'anything' '.*'" "0"
assert_raises "$func 'asd' 'ASD'" "1"
assert_raises "$func 'asd' 'ASD' '1'" "0"
assert_raises "$func 'asd' 'asd' ''" "0"

assert_raises "$func 'nopenope' 'asd'" "1"
assert_raises "$func" "2"
assert_raises "$func 'asd'" "2"
assert_raises "$func '' '' '' ''" "2"
