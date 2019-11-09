#!/usr/bin/env bash
# vim: set filetype=sh
#
# Author: Cody Hiar
# Date: 2019-04-26
#
# Description: Search buffer for unix paths in current tmux pane and send
# results to fzf to copy to clipboard

URL=$(tmux capture-pane -pS -30000 | perl -wnl -e '/\S*(html|py|md|txt|pdf|js|ini|json)$/ and print $&' | awk '!x[$0]++' | fzf-tmux)
if [[ -n "$URL" ]]; then
    echo "$URL" | xp
fi
