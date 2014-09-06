#! /bin/sh

# Define Colors: Stolen From https://github.com/mathiasbynens/dotfiles/blob/master/.bash_prompt
#if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
#    export TERM="gnome-256color"
#elif infocmp xterm-256color >/dev/null 2>&1; then
#    export TERM="xterm-256color"
#fi

RED="\e[0;31m"
ORANGE="\033[1;33m"
YELLOW="\e[0;33m"
GREEN="\033[1;32m"
BLUE=""
LIGHT_BLUE=""
PURPLE="\033[1;35m"
PINK=""
WHITE="\033[1;37m"
GRAY=""
GREY=""
BLACK="\e[0;30m"
BROWN=""
CYAN="\e[0;36m"
# Extras
BOLD=""
RESET="\033[m"
DIM=""

if command -v 'tput' > /dev/null; then
    if [ "$(tput colors)" -ge 256 ]; then
        RED="$(tput setaf 196)"
        ORANGE="$(tput setaf 202)"
        YELLOW="$(tput setaf 226)"
        GREEN="$(tput setaf 34)"
        BLUE="$(tput setaf 21)"
        LIGHT_BLUE="$(tput setaf 51)"
        PURPLE="$(tput setaf 58)"
        PINK="$(tput setaf 171)"
        WHITE="$(tput setaf 255)"
        GRAY="$(tput setaf 244)"
        GREY="$(tput setaf 244)"
        BLACK="$(tput setaf 256)"
        BROWN="$(tput setaf 130)"
        CYAN="$(tput setaf 39)"
    else
        RED="$(tput setaf 1)"
        ORANGE=""
        YELLOW="$(tput setaf 3)"
        GREEN="$(tput setaf 2)"
        BLUE="$(tput setaf 4)"
        LIGHT_BLUE=""
        PURPLE=""
        PINK="$(tput setaf 5)"
        WHITE="$(tput setaf 7)"
        GRAY=""
        GREY=""
        BLACK="$(tput setaf 0)"
        BROWN=""
        CYAN="$(tput setaf 6)"
    fi
    BOLD="$(tput bold)"
    RESET="$(tput sgr0)"
    DIM="$(tput dim)"
fi

return 0
