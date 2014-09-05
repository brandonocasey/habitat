#! /usr/bin/env bash

in_path=""
for p in ${PATH//:/$'\n'} ; do in_path="$p" ; done
func="pathrm"
assert_raises "$func '$in_path'" "0"
assert_raises "$func '/not/in/path'" "1"
assert_raises "$func" "2"
assert_raises "$func ''" "2"
assert_raises "$func 'asd' 'asd'" "2"
