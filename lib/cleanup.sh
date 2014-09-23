#! /bin/sh
function habitat_get_functions() {
    local search="$1"; shift
    local all_functions="$(declare -F | sed -e 's~declare -f ~~g')"
    echo "$(echo "$all_functions" | grep -E "$search")"
}

function habitat_get_vars() {
    local search="$1"; shift
    local all_variables="$( (set -o posix ; set) | sed -e 's~=.*~~')"
    echo "$(echo "$all_variables" | grep -E "$search")"
}


function habitat_cleanup() {
    log.sh --header "Cleanup"
    local start_seconds="$habitat_start_seconds"
    log.sh "Cleaning up habitat_ variables and functions"

    # Extension Cleanup
    local extension
    (while read extension; do
        log.sh "Cleaning up ${extension}_ vars and functions"
        local extension_var
        while read extension_var; do
            log.sh --debug "Unsetting var $extension_var"
            unset "$extension_var"
        done <<< "$(habitat_get_vars "^${extension}_")"

        local extension_function
        while read extension_function;do
            log.sh --debug "Unsetting function $extension_function"
            unset -f "$extension_function"
        done <<< "$(habitat_get_functions "^${extension_function}_")"

    done <<< "$(habitat_extension_names)")


    log.sh "Cleaning up habitat_ vars and functions"
    local habitat_func
    for habitat_func in $(habitat_get_functions "^habitat_"); do
        log.sh --debug "Unsetting function $habitat_func"
        if [ "$habitat_func" != "habitat_get_vars" ] && [ "$habitat_func" != "habitat_cleanup" ]; then
            unset -f "$habitat_func"
        fi
    done

    local habitat_var
    for habitat_var in $(habitat_get_vars "^habitat_"); do
        log.sh --debug "Unsetting var $habitat_var"
        unset "$habitat_var"
    done
    log.sh "Habitat all done at $(date)"
    log.sh "All done after $(($(date +%s)-$start_seconds))"

    unset "CUSTOM_LOG_FILE"
    unset -f "habitat_get_vars"
    unset -f "habitat_cleanup"
}

