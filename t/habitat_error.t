# with blank args
assert_raises "habitat_error '' '' ''" "0"
assert "habitat_error '' '' '' 2>&1"
assert "habitat_error 'hello'"
assert "habitat_error 'hello' 2>&1" "Error: hello"
