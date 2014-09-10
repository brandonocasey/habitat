#! /bin/sh

if [ -z "$1" ] || [ -z "$2" ]; then
	echo "Url or git repo  and output directory are required"
	exit 2
fi
url_or_git_repo="$1"; shift
output_dir="$1"; shift
if [ -n "$(echo "$url_or_git_repo" | grep -E '^(git|http)://')" ]; then
	cd $output_dir && git pull >> "$custom_log_file"
fi
