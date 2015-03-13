#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_usage"
assert_raises "$func" "0"

assert_end "$func"
