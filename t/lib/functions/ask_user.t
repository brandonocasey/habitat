#! /usr/bin/env bash

# simulate sig_int? control+c
# invalid input
func="ask_user"
assert_raises "$func 'Do you want to?'" "0" "y"
assert_raises "$func 'Do you want to?'" "0" "Y"
assert_raises "$func 'Do you want to?'" "0" "Yes"
assert_raises "$func 'Do you want to?'" "0" "yes"
assert_raises "$func 'Do you want to?'" "1" "n"
assert_raises "$func 'Do you want to?'" "1" "N"
assert_raises "$func 'Do you want to?'" "1" "No"
assert_raises "$func 'Do you want to?'" "1" "no"
assert_raises "$func 'Do you want to?'" "1" '\n'
assert_raises "$func 'Do you want to?'" "1" '\n'
assert_raises "$func" "2"
assert_raises "$func '' " "2"
assert_raises "$func '' ''" "2"
