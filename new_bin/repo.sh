#! /bin/sh
#
# repo_action.sh
# Copyright (C) 2014 CORPcasey <CORPcasey@Brandon-Caseys-iMac.local>
#
# Distributed under terms of the MIT license.
#

# Define
NO_TYPE=0
GIT_TYPE=1
SVN_TYPE=2
MER_TYPE=3


function check_repo_status() {
    local repo_dir="$1"; shift
    local repo_type="$1"; shift


    # http://stackoverflow.com/a/3278427
    if [ "$repo_type" -eq "$GIT_TYPE" ]; then
        local local_rev="$(cd "$repo_dir" && git rev-parse @{0})"
        local remote_rev="$(cd "$repo_dir" && git rev-parse @{u})"
        local base_rev="$(cd "$repo_dir" && git merge-base @{0} @{u})"

        if [ "$local_rev" = "$remote_rev" ]; then
            echo "Up-to-date"
        elif [ "$local_rev" = "$base_rev" ]; then
            echo "Need to pull"
        elif [ "$remote_rev" = "$base_rev" ]; then
            echo "Need to push"
        else
            echo "Diverged"
        fi
    fi
}

function get_repo_type() {
    local repo_dir="$1"; shift
    if [ -d "$repo_dir/.git" ]; then
        echo "$GIT_TYPE"
    elif [ -d "$repo_dir/.svn" ]; then
        echo "$SVN_TYPE"
    fi
}

function update_repo() {
    local repo_dir="$1"; shift
    local repo_type="$1"; shift

    if [ "$repo_type" -eq "$GIT_TYPE" ]; then
        (cd "$repo_dir" && git pull "$repo_dir")
    elif [ "$repo_type" -eq "$SVN_TYPE" ]; then
        svn up "$repo_dir"
    fi
}

function download_repo() {
    local repo_url="$1"; shift
    local repo_type="$1"; shift

    if [ "$repo_type" -eq "$GIT_TYPE" ]; then
        (cd "$repo_dir" && git pull "$repo_dir")
    elif [ "$repo_type" -eq "$SVN_TYPE" ]; then
        svn up "$repo_dir"
    fi


}
