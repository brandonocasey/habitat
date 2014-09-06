#! /bin/sh

# Check if a variable isset even through nounset
function isset() {
    eval "local thing=\${$1:-}"
    if [ ! -z "${thing:-}" ]; then
        return 0
    fi
    return 1
}

