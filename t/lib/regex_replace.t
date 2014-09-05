#! /usr/bin/env bash
func="regex_replace"
assert "$func 'bash' 's~sh~~'" "ba"
assert "$func 'bash' 's~ba~~'" "sh"

assert_raises "$func 'bash' 's~'" "2"
assert_raises "$func 'bash' 's~'" "2"

assert_raises "$func 'bash' ''" "2"
assert_raises "$func '' 'bash'" "2"
assert_raises "$func ''" "2"
assert_raises "$func '' ''" "2"
assert_raises "$func" "2"
