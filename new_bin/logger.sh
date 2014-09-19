#! /bin/sh
source "$( cd "$(dirname $0 )/.." && pwd)/lib/main.sh"

# TODO:
# * Prefix on stdout?
# * Prefix in the log is broken

function get_prefix() {
    local prefix=""
    if [ "$action" = "--stdout" ]; then
        prefix=""
    elif [ -z "$CUSTOM_LOG_PREFIX" ]; then
        prefix="$(eval "$CUSTOM_LOG_PREFIX")"
    else
        prefix="$(date): "
    fi
    echo "$prefix"
}

function log() {
    local no_prefix="$1"; shift
    (while read -r line;do
        if [ -n "$line" ]; then
            if [ -n "$use_prefix" ]; then
                echo "$line"
            else
                echo "$(get_prefix) $line"
            fi
        fi
    done <<< "$log_lines")
} 1>&3



function log_header() {
    local header="$1"; shift
}

function log_result() {
    echo "NYI"
}


log_lines=""
# if stdin is a tty: process command line
if [ ! -t 0 ]; then
    while read var; do
        log_lines+="${var}${nl}"
    done
fi

header=""
file=""
level=""
result=""

help=""
help+="# Anything passed without -- is assumed to be a log line/part of a command$nl"
help+="# Environment Variables:$nl"
help+="# CUSTOM_LOG_FILE - file to log to or stdout for stdout$nl"
help+="# CUSTOM_LOG_LEVEL - Current log level$nl"
help+="# CUSTOM_LOG_PREFIX - Custom log prefix$nl"

help+="header Print log lines in header format$nl"
help+="stdout Log to stdout instead of file$nl"
help+="result Log the result of a command$nl"
help+="file The file to log export CUSTOM_LOG_FILE$nl"


help+="error log to level 1$nl"
help+="info  log to level 2$nl"
help+="debug log to level 3$nl"
help+="devel log to level 4$nl"
while [ "$#" -gt "0" ]; do
    arg="$1"; shift
    case $arg in
        --help)
        usage "$help"
        ;;
        --header)
        if [ -z "$1" ]; then
            argument_error "Must have an argument after $arg"
        fi
        action="$arg"
        arg1="$1"; shift
        ;;
        --file)
        if [ -z "$1" ]; then
            argument_error "Must have an argument after $arg"
        fi
        file="$1"; shift
        ;;
        --level)
        if [ -z "$1" ]; then
            argument_error "Must have an argument after $arg"
        fi
        level="$1"; shift
        ;;
        --*)
            argument_error "Invalid Argument $arg"
        ;;
        *)
            log_lines+="${arg}${nl}"
        ;;
    esac
done

if [ "$level" ]; then
    validation_error "A log level must be set"
fi
if [ -z "$log_lines" ]; then
    validation_error "Must pass in lines to log"
fi

if [ "$action" != "--stdout" ]; then
    if [ -z "$file" ] && [ -z "$CUSTOM_LOG_FILE" ]; then
        validation_error "A Log file must be set with --file or CUSTOM_LOG_FILE"
    elif [ -z "$file" ]; then
        log_file="$CUSTOM_LOG_FILE"
    fi
    exec 3>> "$file"
fi

if [ "$action" = "--error" ] && [ "$current_level" -ge "1" ]; then
    log
    exec 3>&2
    log "0"
elif [ "$action" = "--info" ] && [ "$current_level" -ge "2" ]; then
    log
elif [ "$action" = "--debug" ] && [ "$current_level" -ge "3" ]; then
    log
elif [ "$action" = "--devel" ] && [ "$current_level" -ge "4" ]; then
    log
elif [ "$action" = "--stdout" ]; then
    exec 3>&1
    log "0"
elif [ "$action" = "--header" ]; then
    log_header
elif [ "$action" = "--result" ]; then
    log_result
fi

exec 3>&-
exit 0
