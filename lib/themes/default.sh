#==============================================================
# => Bash Prompt
#
# Make your bash prompt look awesome, and make its colors
# differ if you are the root user
#==============================================================

_smiley () {
    if [ $? -eq 0 ]; then
        echo "$LIGHT_BLUE:)$RESET"
    else
        echo "$RED:($RESET"
    fi
}

# Fancy Shell
if [ $(id -u) -ne 0 ]; then
    COLOR_TWO=$LIGHT_BLUE
    COLOR_THREE=$GREY
    COLOR_FOUR=$CYAN
    COLOR_FIVE=$LIGHT_BLUE
else
    COLOR_TWO=$RED
    COLOR_THREE=$ORANGE
    COLOR_FOUR=$YELLOW
    COLOR_FIVE=$BROWN
fi

export PS1=\
"\$(_smiley)"\
"\[${WHITE}\]"\
" \T "\
"\[${COLOR_THREE}\]"\
"\u"\
"\[${WHITE}\]"\
"@"\
"\[${COLOR_FOUR}\]"\
"\h"\
"\[${WHITE}\]"\
":"\
"\[${WHITE}\]"\
"\w"\
"\[${WHITE}\]"\
"\[${RESET}\]"\
"\[${RESET}\]\n"\
"\[${COLOR_FIVE}\]"\
"\$"\
"\[${RESET}\]"\
" "
