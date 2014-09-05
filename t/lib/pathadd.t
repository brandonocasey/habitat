#! /usr/bin/env bash

in_path=""
for p in ${PATH//:/$'\n'} ; do in_path="$p" ; done
func="pathadd"
assert_raises "$func '/thing/thing'" "0"
assert_raises "$func '$in_path'" "1"
assert_raises "$func 'bin'" "0"
assert_raises "$func '/bin'" "1"
assert_raises "$func" "2"
assert_raises "$func ''" "2"
assert_raises "$func 'asd' 'asd'" "2"
