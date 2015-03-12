#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_is_valid_plugin_name"



function setup() {
  :
}
function clean() {
  :
}


#
#
#
setup
plugin=""
test_name "no plugin - failure"
assert_raises "$func '$plugin'" "1"
clean

#
#
#
setup
plugin="nope"
test_name "author only passed - failure"
assert_raises "$func '$plugin'" "1"
clean


#
#
#
setup
plugin="nope/"
test_name "author only with slash passed - failure"
assert_raises "$func '$plugin'" "1"
clean

#
#
#
setup
plugin="/asd"
test_name "plugin only - failure"
assert_raises "$func '$plugin'" "1"
clean

#
#
#
setup
plugin="/asd/asd"
test_name "plugin + author extra slash at start - failure"
assert_raises "$func '$plugin'" "1"
clean

#
#
#
setup
plugin="asd/asd/"
test_name "plugin + author extra slash at end - failure"
assert_raises "$func '$plugin'" "1"
clean

#
#
#
setup
plugin="a sd/asd"
test_name "plugin + author author has a space character - failure"
assert_raises "$func '$plugin'" "1"
clean

#
#
#
setup
plugin="asd/a sd"
test_name "plugin + author plugin has a space character - failure"
assert_raises "$func '$plugin'" "1"
clean

#
#
#
setup
plugin="a.sd/asd"
test_name "plugin + author author has a special character - failure"
assert_raises "$func '$plugin'" "1"
clean

#
#
#
setup
plugin="asd/a.sd"
test_name "plugin + author plguin has a special character - failure"
assert_raises "$func '$plugin'" "1"
clean



#
#
#
setup
plugin="asd/asd"
test_name "plugin + author multiple characters and valid - success"
assert_raises "$func '$plugin'" "0"
clean

#
#
#
setup
plugin="d/d"
test_name "plugin + author single characters and valid - success"
assert_raises "$func '$plugin'" "0"
clean

#
#
#
setup
plugin="0/0"
test_name "plugin + author single number and valid - success"
assert_raises "$func '$plugin'" "0"
clean


#
#
#
setup
plugin="00/00"
test_name "plugin + author multiple numbers and valid - success"
assert_raises "$func '$plugin'" "0"
clean


#
#
#
setup
plugin="0a0/0a0"
test_name "plugin + author numbers/characters and valid - success"
assert_raises "$func '$plugin'" "0"
clean

#
#
#
setup
plugin="Aa0/Aa0"
test_name "plugin + author numbers/characters upper and lower and valid - success"
assert_raises "$func '$plugin'" "0"
clean


assert_end "$func"
