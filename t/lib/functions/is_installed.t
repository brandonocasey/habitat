#! /usr/bin/env bash
func="is_installed"
assert_raises "$func 'bash'" "0"
assert_raises "$func 'nopenope'" "1"
assert_raises "$func" "2"
assert_raises "$func ''" "2"
assert_raises "$func '' ''" "2"
assert_raises "$func 'space space space'" "1"
