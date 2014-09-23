#! /bin/sh
#
# extension.sh
# Copyright (C) 2014 CORPcasey <CORPcasey@Brandon-Caseys-iMac.local>
#
# Distributed under terms of the MIT license.
#

function habitat_install_extension() {
    local extension_name="$1"; shift
    local save="$1"; shift

    dir="$(repo.sh --download "$extension_name" "$habitat_tmp")"

    # stuff into author name dir
    local author="$(echo "$extension_name" | sed 's~\(.*\)/.*~\1~' | sed 's~.*/~~')"
    mkdir "$habitat_extensions/$author"
    mv -R $habitat_tmp/$dir "$habitat_extensions/$author/$dir"

}

function habitat_remove_extension() {
    local extension_dir="$1"; shift
    local save="$1"; shift
    rm -rf "$extension_dir"
}

function habitat_update_extension() {
    local extension_dir="$1"; shift
    local config_setting="$1"; shift
    if [ -z "$config_setting" ]; then
        config_setting="auto"
    fi
    repo.sh --update "$extension_dir"

}

function habitat_extension_deployment() {
    log.sh --header "Extensions"
    local dir
    locl extension=""
    (while read extension; do
        log.sh "Sourcing $dir/extension.habit"
        source "$dir/extension.habit"
    done <<< "$(habitat_extension_directories)")

    log.sh --header "A - Setup"
    habitat_extension_action "setup"

    log.sh --header "B - Deploy"
    habitat_extension_action "deploy"

    log.sh --header "C - Cleanup"
    habitat_extension_action "cleanup"

}

function habitat_extension_action() {
    local action="$1"; shift
    local extension
    (while read extension; do
        if [ -n "$(type "${extension}_$action" 2>&1 | grep -i -E 'is a function')" ]; then
            log.sh "Running ${extension}_$action"
            "${extension}_$action"
        else
            log.sh "${extension}_$action was skipped as it does not exist"
        fi
    done <<< "$(habitat_extension_names)")
}


