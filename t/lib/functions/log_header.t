#! /usr/bin/env bash
func="log_header"
stub_and_echo "log" "stub_log_called"
assert "$func 'log'" 'stub_log_called'
assert_raises "$func 'log'" '0'
assert_raises "$func ''" '2'
assert_raises "$func '' ''" '2'
assert_raises "$func" '2'
restore 'log'

