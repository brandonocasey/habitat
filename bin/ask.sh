#! /bin/sh
source "$( cd "$(dirname $0 )/.." && pwd)/lib/main.sh"

question=""
answers=""
default=""

opt "question|q" "Question to ask the user"
opt "answers|a"  "Pipe deliminated answers where default is the first asd|dsa|no|yes"
parse_args "$@"
while [ "$#" -gt "0" ]; do
    arg="$1"; shift
    case $arg in
        --question|-q|--q|--question)
            if [ -z "$1" ]; then
                error "Must have an argument after $arg"
            fi
            if [ -n "$question" ]; then
                error "Cannot ask two $question and $1"
            fi
            question="$1"; shift
        ;;
        --answers|-a|--a|-answers|--answer|-answer)
            if [ -z "$1" ]; then
                error "Must have an argument after $arg"
            fi
            if [ -z "$1" ]; then
                error "Cannot have two answers $answers and $1"
            fi
            answers="$1"; shift
        ;;
        *)
            error "Invalid Argument $arg"
        ;;
    esac
done

if [ -z "$question" ]; then
    error "A question must be defined"
fi

if [ -z "$answers" ]; then
    error "An answer must be defined"
fi


function check_against_answers() {
    local answer="$1"; shift
    if echo "$answer" | grep -E -q "$answers"; then
        echo "0"
        return
    fi
    echo "1"
}


# grab the first answer and make it the default
default="$(while IFS='|' read -ra first_answer; do
    echo "$first_answer"
    break
done <<< "$answers")"

# if user hits control + c use default
trap "echo '$default'; exit 0" SIGINT

answered="1"
while [ "$answered" -ne "0" ]; do
    echo "$question? [$answers]" 1>&2
    read -e answer
    # if user hits enter use default
    if [ -z "$answer" ]; then
        answer="$default"
    fi
    answered="$(check_against_answers "$answer")"
done

echo "$answer"
exit 0
