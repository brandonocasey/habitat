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

# 0 no prefix
# 1 header
# 2 prefix
function log() {
    local setting="$1"; shift
    local line=""
    (while read -r line;do
        if [ -n "$line" ]; then
            if [ "$setting" -eq "1" ]; then
                line="*----$line----*"
            elif [ "$setting" -eq "2" ]; then
                line="$(get_prefix) $line"
            fi
            echo "$line"
        fi
    done <<< "$log_lines")
} 1>&3


# Run the command and pipe the output to this binary
# have this binary print to stdout
# redirect stdout to the log
function log_result() {
    echo "Running $@"
    "$@" 2>&1
    echo "Return Code "$?"
} 1>&3

function log_header() {
    (while read -r line;do
        if [ -n "$line" ]; then
            echo "*----$line----*" 2>&1
        fi
    done <<< "$log_lines")
} 1>&3


log_lines=""
action=""
file=""

opt "#"      "Anything passed without -- is assumed to be a log line/part of a command"
opt "#"      "Environment Variables:"
opt "#"      "CUSTOM_LOG_FILE - file to log to or stdout for stdout"
opt "#"      "CUSTOM_LOG_LEVEL - Current log level default is 2"
opt "#"      "CUSTOM_LOG_PREFIX - Custom log prefix"
opt "file"   "The file to log export CUSTOM_LOG_FILE"
opt "header" "Print log lines in header format"
opt "stdout" "Log to stdout instead of file"
opt "result" "Log the result of a command"
opt "error"  "log to level 1"
opt "info"   "log to level 2"
opt "debug"  "log to level 3"
opt "devel"  "log to level 4"
parse_args "$@"
while [ "$#" -gt "0" ]; do
    arg="$1"; shift
    case $arg in
        --error)
            if [ -n "$level" ]; then
                error "Cannot print to $level and $arg"
            fi
            level="1"
        ;;
       --info)
            if [ -n "$level" ]; then
                error "Cannot print to $level and $arg"
            fi
            level="2"
        ;;
        --debug)
            if [ -n "$level" ]; then
                error "Cannot print to $level and $arg"
            fi
            level="3"
        ;;
         --devel)
            if [ -n "$level" ]; then
                error "Cannot print to $level and $arg"
            fi
            level="4"
        ;;
        --header|--stdout|--result)
            if [ -n "$action" ]; then
                error "Cannot run $action and $arg"
            fi
            action="$arg"
        ;;
        --file)
            if [ -z "$1" ]; then
                error "Must have an argument after $arg"
            fi
            file="$1"; shift
        ;;
        *)

            if [ -z "$log_lines" ]; then
                log_lines+="${arg}"
            else
                log_lines+="${nl}${arg}"
            fi
        ;;
    esac
done

if [ -z "$level" ]; then
    level="2"
fi
if [ -z "$CURRENT_LOG_LEVEL" ]; then
    current_level="2"
else
    current_level="$CURRENT_LOG_LEVEL"
fi

if [ -z "$log_lines" ]; then
    error "You must pass in lines to log or a command"
fi

if [ "$action" != "--stdout" ]; then
    if [ -z "$file" ] && [ -z "$CUSTOM_LOG_FILE" ]; then
        error "A Log file must be set with --file or CUSTOM_LOG_FILE"
    elif [ -z "$file" ]; then
        log_file="$CUSTOM_LOG_FILE"
    fi
    if [ ! -f "$log_file" ]; then
        touch "$log_file"
    fi
    exec 3>> "$log_file"
fi

log_settings="0"
if [ "$action" = "--result" ]; then
    log_result "$log_lines"
elif [ "$action" = "--stdout" ]; then
    exec 3>&1
    log.sh "2"
else
    if [ "$current_level" -ge "$level" ]; then
        if [ "$action" = "--header" ]; then
            log_settings="2"
        fi
        log "$log_settings"
        if [ "$level" = "--error" ]; then
            exec 3>&2
            log "$log_settings"
        fi
    fi
fi


exec 3>&-
exit 0
