#! /bin/sh

if [ -z "$1" ] || [ -z "$2" ]; then
	echo "Url or git repo  and output directory are required"
	exit 2
fi
url_or_git_repo="$1"; shift
output_dir="$1"; shift
url=""
if [ -n "$(echo "$url_or_git_repo" | grep -E '^(git|http|https)://')" ]; then
	url="$url_or_git_repo"
elif [ -n "$(echo "$url_or_git_repo" | grep -E '^.*/.*$')" ]; then
	url="$(echo "$url_or_git_repo" | sed -e 's~ ~~g')"
	url="https://github.com/${url}.git"
fi

if [ -z "$1" ]; then
	(cd "$output_dir"; git clone "$url")
else
	(cd "$output_dir"; git clone "$url" "$1")
fi
