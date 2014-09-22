#! /bin/sh
#
# repo_action.sh
# Copyright (C) 2014 CORPcasey <CORPcasey@Brandon-Caseys-iMac.local>
#
# Distributed under terms of the MIT license.
#

source "$( cd "$(dirname $0 )/.." && pwd)/lib/main.sh"
# Define
NO_TYPE=0
GIT_TYPE=1
SVN_TYPE=2
MER_TYPE=3


function status() {
    local repo_dir="$1"; shift
    local local_rev
    local remote_rev
    local base_rev

    # http://stackoverflow.com/a/3278427
    if [ "$repo_type" -eq "$GIT_TYPE" ]; then
        local_rev="$(cd "$repo_dir" && git rev-parse @{0})"
        remote_rev="$(cd "$repo_dir" && git rev-parse @{u})"
        base_rev="$(cd "$repo_dir" && git merge-base @{0} @{u})"

        if [ "$local_rev" = "$base_rev" ]; then
            # Need to pull
            exit 0
        fi
    elif [ "$repo_type" -eq "$SVN_TYPE" ]; then
        local_rev="$(svn info | grep -i "Last Changed Rev")"
        remote_rev="$(svn info -r HEAD | grep -i "Last Changed Rev")"

        if [ "$local_rev" != "$remote_rev" ]; then
            exit 0
        fi
    fi

    # up to date or not a repo
    exit 1
}

function type() {
    local repo="$1"; shift
    if [ -n "$(echo "$repo" | grep -E "^(https|git)://.*.git$")" ]; then
        echo "$GIT_TYPE"
    elif [ -n "$(echo "$repo" | grep -E "^svn+ssh")" ]; then
        echo "$SVN_TYPE"
    elif [ -d "$repo" ]; then
        if [ -d "$repo_dir/.git" ]; then
            echo "$GIT_TYPE"
        elif [ -d "$repo_dir/.svn" ]; then
            echo "$SVN_TYPE"
        fi
    elif [ -n "$(echo "$repo" | grep ".*/.*")" ]; then
        echo "$GIT_TYPE"
    else
        validation_error "Unable to determine repo type of $repo"
    fi
}

function update() {
    local repo_dir="$1"; shift

    if [ "$repo_type" -eq "$GIT_TYPE" ]; then
        (cd "$repo_dir" && git pull "$repo_dir")
    elif [ "$repo_type" -eq "$SVN_TYPE" ]; then
        svn up "$repo_dir"
    fi
    exit 0
}

function download() {
    local repo_url="$1"; shift
    local end_location="$1"; shift

    if [ "$repo_type" -eq "$GIT_TYPE" ]; then
        local dir="$(echo "$extension_name" | sed 's~.*/\(.*\)~\1~')"
        git clone "$repo_url" "$end_location"
        echo "$dir"
    elif [ "$repo_type" -eq "$SVN_TYPE" ]; then
        svn co "$repo_url" "$end_location"
    fi
}


action=""
help=""
help+="download <url> <dir> download a repo$nl"
help+="status   <dir> get the status of a rrepo$nl"
help+="# return code of 1 indicates everything is up to date$nl"
help+="# return code of 0 indicates updates are possible$nl"
help+="update   <dir> update a repo$nl"
while [ "$#" -gt "0" ]; do
    arg="$1"; shift
    case $arg in
        --help)
            usage "$help"
        ;;
        --i)
            insensitive="0"
        ;;
        --download)
            if [ -n "$action" ]; then
                argument_error "Cannot do $arg and $action"
            fi
            if [ -z "$1" ]; then
                argument_error "$arg requires an argument"
            fi
            arg1="$1"; shift
            arg2="$1"; shift
        ;;
        --status|--update)
            if [ -n "$action" ]; then
                argument_error "Cannot do $arg and $action"
            fi
            if [ -z "$1" ]; then
                argument_error "$arg requires an argument"
            fi
            action="$arg"
            arg1="$1"; shift
        ;;
        *)
            argument_error "Invalid Argument $arg"
        ;;
    esac
done

repo_type=$(type "$arg1")

if [ "$action" = "--download" ]; then
    download "$arg1" "$arg2"
elif [ "$action" = "--status" ]; then
    status "$arg1"
elif [ "$action" = "--update" ]; then
    update "$arg1"
fi
