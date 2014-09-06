#! /usr/bin/env bash

func="link_files"
stub "info"
backup="$tmp_dir/backup"
mkdir -p "$backup"

backup_dest="$backup/link"
source="$tmp_dir/thing"
dest="$tmp_dir/link"

# Make sure a symlink works
touch "$source"
$func "$backup" "$source" "$dest"
assert_raises "test -f '$source'" "0"
assert_raises "test ! -f '$backup_dest'" "0"
assert_raises "unlink '$dest'" "0"
rm -f "$source"
rm -f "$backup_dest"


# Make sure backup works for a file
touch "$source"
touch "$dest"
$func "$backup" "$source" "$dest"
assert_raises "test -f '$source'" "0"
assert_raises "test -f '$backup_dest'" "0"
assert_raises "unlink $dest" "0"
rm -f "$source"
rm -f "$backup_dest"

# Make sure it works for a dir
touch "$source"
mkdir "$dest"
$func "$backup" "$source" "$dest"
assert_raises "test -d $backup_dest" "0"
assert_raises "test -f $source" "0"
assert_raises "unlink $dest" "0"
rm -rf "$backup_dest"
rm -rf "$source"

# make sure we can symlink a dir
mkdir "$source"
mkdir "$dest"
$func "$backup" "$source" "$dest"
assert_raises "test -d $backup_dest" "0"
assert_raises "test -d $source" "0"
assert_raises "unlink $dest" "0"
rm -rf "$backup_dest"
rm -rf "$source"


# Make sure symlinks are overwritten
mkdir "$source"
mkdir "$dest"
ln -s "$tmp_dir/ping" "$tmp_dir/bats"
touch "$tmp_dir/thing"
$func "$backup" "$tmp_dir/thing" "$tmp_dir/ping"
assert_raises "unlink $tmp_dir/ping" "0"
assert_raises "test ! -L $backup/ping" "0"
rm -rf "$backup/ping"


assert_raises "$func '' '' ''" "2"
assert_raises "$func '' ''" "2"
assert_raises "$func ''" "2"
assert_raises "$func" "2"
assert_raises "$func 'asd'" "2"
assert_raises "$func 'asd' 'asd'" "2"
assert_raises "$func 'asd' 'asd' 'asd' 'asd'" "2"

restore "info"
