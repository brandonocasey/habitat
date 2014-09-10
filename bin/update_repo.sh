#! /bin/sh
#
# update_repo.sh
# Copyright (C) 2014 bcasey <bcasey@brandons-air>
#
# Distributed under terms of the MIT license.
#


if [ -z "$1" ]; then
	echo "Must Pass a directory to update"
	exit 2
fi

code="1"
dir="$1"; shift
if [ -d "$dir/.svn" ]; then
	svn up $dir
	code="0"
fi
if [ -d "$dir/.git" ]; then
	(cd $dir && git pull)
	code="0"
fi

if [ "$code" -eq "1" ]; then
	echo "Repo in $dir was not found"
fi
exit "$code"
