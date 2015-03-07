#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0"
func="habitat_source_installed_plugins"


function setup() {
  stub 'habitat_source'
  if [ -d "$tmp" ]; then
    rm -rf "$tmp"/*
  fi
  while [ $# -gt 0 ]; do
    local author="${1:-}"; shift
    local plugin="${1:-}"; shift
    if [ -z "${author:-}" ]; then
      continue
    fi
    if [ ! -d "$tmp/$author" ]; then
      mkdir -p "$tmp/$author"
    fi

    if [ -z "${plugin:-}" ]; then
      continue
    fi
    if [ ! -f "$tmp/$author/$plugin" ];then
      touch "$tmp/$author/$plugin"
    fi
  done
}
function clean() {
  restore 'habitat_source'
  if [ -d "$tmp" ]; then
    rm -rf "$tmp"/*
  fi
}

#
#
# no authors no plugins
#
#
setup
$func "$tmp"
assert "echo '$?'" "1"
clean


#
#
# one author with no plugins
#
#
setup "author"
$func "$tmp"
assert "stub_called_times 'habitat_error'" "1"
clean

#
#
# one author one plugins
#
#
setup "author" "plugin"
$func "$tmp"
assert "stub_called_times 'habitat_source'" "1"
clean


#
#
# one author with two plugins
#
#
setup "author" "plugin" "author" "plugin2"
$func "$tmp"
assert "stub_called_times 'habitat_source'" "2"
clean

#
#
# two author with one plugins each
#
#
setup "author" "plugin" "author2" "plugin"
$func "$tmp"
assert "stub_called_times 'habitat_source'" "2"
clean


#
#
# two author with only one has a plugin
#
#
setup "author" "plugin" "author2"
$func "$tmp"
assert "stub_called_times 'habitat_source'" "1"
clean


assert_end "$func"
