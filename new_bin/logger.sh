#! /bin/sh
source "$( cd "$(dirname $0 )/.." && pwd)/lib/main.sh"

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
            if [ -n "$no_prefix" ]; then
                echo "$line"
            else
                echo "$(get_prefix) $line"
            fi
        fi
    done <<< "$log_lines")
} 1>&3


# Run the command and pipe the output to this binary
# have this binary print to stdout
# redirect stdout to the log
function log_result() {
    "$@" 2>&1 | "$0 --stdout"
} 1>&3

function log_header() {
    (while read -r line;do
        if [ -n "$line" ]; then
            echo "*----$line----*" 2>&1
        fi
    done <<< "$log_lines")
} 1>&3


log_lines=""
# if stdin is a tty: process command line
if [ ! -t 0 ]; then
    while read var; do
        log_lines+="${var}${nl}"
    done
fi

action=""
file=""

help=""
help+="# Anything passed without -- is assumed to be a log line/part of a command$nl"
help+="# Environment Variables:$nl"
help+="# CUSTOM_LOG_FILE - file to log to or stdout for stdout$nl"
help+="# CUSTOM_LOG_LEVEL - Current log level default is 2$nl"
help+="# CUSTOM_LOG_PREFIX - Custom log prefix$nl"

help+="file The file to log export CUSTOM_LOG_FILE$nl"


help+="header Print log lines in header format$nl"
help+="stdout Log to stdout instead of file$nl"
help+="result Log the result of a command$nl"
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
        --header|--stdout|--result|--error|--debug|--info|--devel)
        if [ -n "$action" ]; then
            argument_error "Cannot run $action and $arg"
        fi
        action="$arg"
        ;;
        --file)
        if [ -z "$1" ]; then
            argument_error "Must have an argument after $arg"
        fi
        file="$1"; shift
        ;;
        --*)
            argument_error "Invalid Argument $arg"
        ;;
        *)
            log_lines+="${arg}${nl}"
        ;;
    esac
done

if [ -z "$CURRENT_LOG_LEVEL" ]; then
    current_level="2"
else
    current_level="$CURRENT_LOG_LEVEL"
fi

if [ -z "$log_lines" ]; then
    validation_error "You must pass in lines to log or a command"
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
    log_result "$log_lines"
fi

exec 3>&-
exit 0
