#! /bin/sh
#
# file.sh
# Copyright (C) 2014 CORPcasey <CORPcasey@Brandon-Caseys-iMac.local>
#
# Distributed under terms of the MIT license.
#
source "$( cd "$(dirname $0 )/.." && pwd)/lib/main.sh"

# Move, symlink, and copy with automatic backup

function backup() {
    local file="$1"; shift
    local name="$(basename "$file")"
    if [ ! -f "$file" ] && [ ! -d "$file" ] && [ -h "$file" ]; then
        rm "$file"
    elif [  -f "$file" ]; then
        mv "$file" "$backup/$name"
    elif [ -d "$file" ]; then
        mv -R "$file" "$backup/$name"
    fi
}

function move() {
    local file="$1"; shift
    local location="$1"; shift
    if [ -f "$file" ]; then
        mv "$file" "$location"
    else
        mv -R "$file" "$location"
    fi

}

function link() {
    local file="$1"; shift
    local location="$1"; shift
    ln -s "$file" "$location"

}

function copy() {
    local file="$1"; shift
    local location="$1"; shift
    if [ -f "$file" ]; then
        cp "$file" "$location"
    else
        cp -R "$file" "$location"
    fi
}

function full_path() {
    local file="$1"; shift
    local name="/$(basename "$file")"
    if [ "$name" = "." ] ||\
       [ "$name" = ".." ] ||\
       [ "$name" = './' ] ||\
       [ "$name" = '/.' ]; then
        name=""
    fi

    echo "$( cd "$( dirname "$file" )" && pwd )$name"
}

function download() {
    local url="$1"; shift
    local location="$1"; shift
    if command -v 'wget' > /dev/null;then
        wget -O "$location" "$url" -q --no-check-certificate
    elif command -v 'curl' > /dev/null; then
        curl -o "$_location" "$url" -q
    elif command -v 'w3m' > /dev/null; then
        w3m -dump "$url" > "$location"
    elif command -v 'lynx' > /dev/null; then
        lynx -dump "$url" > "$location"
    else
        failure "We require curl, wget, lynx, or w3m to download $url"
    fi
}

function find_this() {
    local search="$1"; shift
    local location="$1"; shift
    find "$location" -name "$search"
}



opt "backup"    "<location> Required for move, copy, link, and download"
opt "move"      "<file> <destination>"
opt "link"      "<file> <destination>"
opt "copy"      "<file> <destination>"
opt "download"  "<url> <destination> download something if possible"
opt "full_path" "<location> full path of a local file"
opt "find"      "<regex_search> <location> Recurive search for anything matching regex"
parse_args "$@"
arg1=""
arg2=""
action=""
while [ "$#" -gt "0" ]; do
    arg="$1"; shift
    case $arg in
        --link|--copy|--move|--download|--find)
            if [ -n "$action" ]; then
                error "Cannot do $action and $arg at the same time"
            fi
            if [ -z "$1" ] || [ -z "$2" ]; then
                error "Must have two arguments after $arg"
            fi
            action="$arg"
            arg1="$1"; shift
            arg2="$(full_path "$1")"; shift
        ;;
        --full_path)
            if [ -n "$action" ]; then
                error "Cannot do $action and $arg at the same time"
            fi
            if [ -z "$1" ]; then
                error "Must have one argument after $arg"
            fi
            action="$arg"
            arg1="$1"; shift
        ;;
        --backup)
            if [ -z "$1" ]; then
                error "Must have one argument after $arg"
            fi
            backup="$1"; shift
        ;;
        *)
            error "Invalid Argument $arg"
        ;;
    esac
done

if [ -z "$action" ]; then
    error "Must pass in an action, --move, --copy etc"
fi
if [ -n "$(echo "$action" | grep '\-\-link|\-\-copy|\-\-download|\-\-move')" ]; then
    if [ -z "$backup" ]; then
        error "Must pass in an arg to --backup for $action"
    fi
    if [ ! -d "$backup" ]; then
        mkdir -p "$(full_path $backup)"
    fi
    backup "$arg2"
fi
if [ -n "$(echo "$action" | grep '\-\-link|\-\-copy|\-\-move')" ]; then
    arg1="$(full_path "$arg1")"
fi
if [ -n "$(echo "$action" | grep '\-\-find|\-\-full_path')" ] && [ -n "$backup" ]; then
    error "Backup is not needed for $action"
fi

if [ "$action" = "--link" ]; then
    link "$arg1" "$arg2"
elif [ "$action" = "--move" ]; then
    move "$arg1" "$arg2"
elif [ "$action" = "--copy" ]; then
    copy "$arg1" "$arg2"
elif [ "$action" = "--download" ]; then
    download "$arg1" "$arg2"
elif [ "$action" = "--find" ]; then
    find_this "$arg1" "$arg2"
elif [ "$action" = "--full_path" ]; then
    full_path "$arg1"
fi

exit 0
