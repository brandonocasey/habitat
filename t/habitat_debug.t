function="habitat_debug"
restore "$function"

# with debug off
assert_raises "$function '' '' ''" "0"
assert "$function '' ''"
assert "$function 'hello'"
assert_raises "$function 'hello'" "0"

# with debug on
habitat_debug_output=1
assert "$function 'hello'" "Debug: hello"
assert_raises "$function 'hello'" "0"
assert "$function '' ''"
