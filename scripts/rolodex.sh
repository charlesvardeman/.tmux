#!/usr/bin/env bash
# vim: set filetype=sh
#
# Author: Cody Hiar
# Date: 2019-01-11
#
# Description: Rolodex script. Consider the following setup
# 
# +------------------------------+-----------------------------+
# |                              |                             |
# |                              |           Pane 3            |
# |                              |                             |
# |        Pane 1                +-----------------------------+
# |                              |                             |
# |                              |         Pane 4              |
# +------------------------------+                             |
# |                              |                             |
# |                              +-----------------------------+
# |       Pane 2                 |                             |
# |                              |                             |
# |                              |       Pane 5                |
# |                              |                             |
# +------------------------------+-----------------------------+
#        Window 1                         Window 2 
#
# This is my standard setup. Pane 1 is vim, pane 2-5 are just used for docker
# or w/e else. I almost always want to stick on Window 1 but I want to cycle
# between pane 2-5. This script will simply rotate them in either direction so
# I can stay in window 1 but have a sort of "tabbed" bottom window
#
# Set options:
#   e: Stop script if command fails
#   u: Stop script if unset variable is referenced
#   x: Debug, print commands as they are executed
#   o pipefail:  If any command in a pipeline fails it all fails
#
# IFS: Internal Field Separator
set -euo pipefail
IFS=$'\n\t'

# Colors for printing
G='\e[0;32m' # Green
LG='\e[0;37m' # Light Gray
C='\e[0;36m' # Cyan
NC='\e[0m' # No Color

# Immutable globals
readonly ARGS=( "$@" )
readonly NUM_ARGS="$#"
readonly PROGNAME=$(basename "$0")

get_number_of_active_window_panes() {
    echo $(tmux lsp | wc -l)
}

get_active_pane(){
    echo $(tmux lsp | grep '(active)' | cut -c 1)
}

get_number_of_buffer_window_panes() {
    echo $(tmux lsp  -t 2 | wc -l)
}

open_drawer_if_unopen() {
    PANE_COUNT=$(get_number_of_active_window_panes)
    if [[ "$PANE_COUNT" == '1' ]]; then
        "$HOME"/.tmux/plugins/tmux-drawer/scripts/open_or_close_drawer.sh
    fi
}

# Main loop of program
main() {
    BUFFER_COUNT=$(get_number_of_buffer_window_panes)
    PANE_COUNT=$(get_number_of_active_window_panes)
    if [[ "$NUM_ARGS" == 0 ]]; then
        ACTION='next'
    elif [[ "$NUM_ARGS" == 1 ]]; then
        ACTION="${ARGS[0]}"
    fi

    ACTIVE_PANE=$(get_active_pane)   
    if [[ "$ACTION" == 'prev' ]]; then
        open_drawer_if_unopen
        tmux swap-pane -s 1.2 -t 2."$BUFFER_COUNT"
        MAX=$((BUFFER_COUNT - 1))
        for i in $(seq 1 "$MAX" | tac); do
            NEXT=$((i + 1))
            tmux swap-pane -s 2."$i" -t 2."$NEXT"
        done
        tmux select-pane -t 1."$ACTIVE_PANE"
    elif [[ "$ACTION" == 'next' ]]; then
        open_drawer_if_unopen
        tmux swap-pane -s 1.2 -t 2.1
        MAX=$((BUFFER_COUNT - 1))
        for i in $(seq 1 "$MAX"); do
            NEXT=$((i + 1))
            tmux swap-pane -s 2."$i" -t 2."$NEXT"
        done
        tmux select-pane -t 1."$ACTIVE_PANE"
    else
        echo "Command not recognized: $ACTION"
    fi
}
main
