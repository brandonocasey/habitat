#!/bin/sh

download="$tmp_dir/download_thing"

function startup() {
	stub_and_eval 'wget' "return 3"
	stub_and_eval 'curl' "return 4"
	stub_and_eval 'w3m' "return 5"
	stub_and_eval 'lynx' "return 6"
	stub_and_eval command "if [ \"\$2\" = \"$1\" ]; then return 0; else return 1; fi "
}

function cleanup() {
	if [ -f "$download" ]; then
		rm -f "$download"
	fi
	restore "wget"
	restore "lynx"
	restore "w3m"
	restore "curl"
	restore "command"
}
script_file="$1"

assert_raises "$script_file ''" "2"
assert_raises "$script_file '' ''" "2"
assert_raises "$script_file '' 'asd' " "2"
assert_raises "$script_file 'asd' '' " "2"


startup "wget"
assert_raises "source $script_file 'things' '$download'" "3"
cleanup

startup "curl"
assert_raises "source $script_file 'things' '$download'" "4"
cleanup

startup "w3m"
assert_raises "source $script_file 'things' '$download'" "5"
assert_raises 'test -f "$download"' "0"
cleanup

startup "lynx"
assert_raises "source $script_file 'things' '$download'" "6"
assert_raises 'test -f "$download"' "0"
cleanup

startup "blank"
assert_raises "source $script_file 'things' '$download'" "2"
cleanup
