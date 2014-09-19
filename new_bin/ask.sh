#! /bin/sh
source "$( cd "$(dirname $0 )/.." && pwd)/lib/shared.sh"

question=""
answers=""

help="question Question to ask the user$nl"
help+="answers Pipe deliminated answers where default is the first asd|dsa|no|yes $nl"
while [ "$#" -gt "0" ]; do
    arg="$1"; shift
    case $arg in
        --help)
        usage "$help"
        ;;
        --question)
        if [ -z "$1" ]; then
            argument_error "Must have an argument after $arg"
        fi
        question="$1"; shift
        ;;
        --answers)
        if [ -z "$1" ]; then
            argument_error "Must have an argument after $arg"
        fi
        answers="${1}"; shift
        ;;
        *)
            argument_error "Invalid Argument $arg"
        ;;
    esac
done

function check_against_answers() {
    local answer="$1"; shift
    while read -r possible_answer; do
        if [ -n "$(echo "$answer" | grep -E -i "$possible_answer")" ]; then
            echo "0"
            return
        fi
    done <<< "$answers"

    echo "1"
}

if [ -z "$question" ]; then
    validation_error "question must be defined with --q"
fi

if [ -z "$answers" ]; then
    validation_error "at least one answer must be defined with --a"
fi

while IFS='|' read -ra first_answer; do
    default="$first_answer"
    continue
done <<< "$answers"

trap "echo $default; exit 0" SIGINT

answered="1"
while [ "$answered" -ne "0" ]; do
    echo "$question? [$answers]" 1>&2
    read -e answer
    if [ -z "$answer" ]; then
        answer="$default"
    fi
    answered="$(check_against_answers "$answer")"
done

echo "$answer"
exit 0
