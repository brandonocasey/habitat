# with debug off
assert_raises "habitat_debug '' '' ''" "0"
assert "habitat_debug '' ''"
assert "habitat_debug 'hello'"
assert_raises "habitat_debug 'hello'" "0"

# with debug on
habitat_debug_output=1
assert "habitat_debug 'hello'" "Debug: hello"
assert_raises "habitat_debug 'hello'" "0"
assert "habitat_debug '' ''"
