#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_one_time_question"

function setup() {
  stub 'habitat_read_config'
  stub 'habitat_write_config'
}
function clean() {
  stub 'habitat_read_config'
  stub 'habitat_write_config'
}


#
#
#
setup
test_name '0 Args'
assert_raises "$func" "1"

test_name '1 Args'
assert_raises "$func '1'" "1"

test_name '2 Args'
assert_raises "$func '1' '1'" "1"

test_name '3 Args'
assert_raises "$func '1' '1' '1'" "1"

clean

#
#
#
setup
restore "habitat_read_config"
stub_and_echo "habitat_read_config" "found"
test_name 'Question already answered'
assert_raises "$func '1' '1' '1' '1'" "1"
clean

#
#
#
setup
test_name 'Question Asked'
assert "$func 'config' 'key' 'question' 'y|n'" "question? [y|n]" "y"

clean

#
# TODO: how to keep habitat_write_config
#
setup
$func 'config' 'key' 'question' 'y|n'

test_name "written to config"
assert "stub_called_times 'habitat_write_config'" "1"
clean



#
# TODO: how to test infinite loop
#
setup
#assert "$func 'config' 'key' 'question' 'y|n'" "question? [y|n]" "q" "y"
clean




assert_end "$func"
