#!/usr/bin/env bash
# vim: set filetype=sh
#
# Author: Cody Hiar
# Date: 2019-04-25
#
# Description: Search tmux pane for urls then pass to fzf
# for copying to clipboard

URL=$(tmux capture-pane -pS -30000 | perl -wnl -e '/https?\:\/\/[^\s]+[\/\w]/ and print $&' | fzf-tmux)
if [[ -n "$URL" ]]; then
    echo "$URL" | xp
fi
