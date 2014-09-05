#! /usr/bin/env bash
func="info"
assert "$func 'some info'" "some info"
assert "$func ''" ""
assert "$func" ""
assert "$func 'asd' 'asd' 'asd'" "asd\nasd\nasd"
assert "$func 'asd' 'asd' ''" "asd\nasd"
assert "$func 'space space'" "space space"
assert "$func 'space space\\'" "space space\\"
