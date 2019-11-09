#!/usr/bin/env bash
# vim: set filetype=sh
#
# Author: Unknown
# Date: 2016-11-09
#
# Description: Renumber tmux windows (1, 3, 4, 6) -> (1, 2, 3, 4)

for session in $(tmux ls | awk -F: '{print $1}') ; do
    active_window=$(tmux lsw -t ${session} | awk -F: '/\(active\)$/ {print $1}')
    inum=1
    for window in $(tmux lsw -t ${session} | awk -F: '{print $1}') ;do
        if [ ${window} -gt ${inum} ] ;then
            echo "${session}:${window} -> ${session}:${inum}"
            tmux movew -d -s ${session}:${window} -t ${session}:${inum}
        fi
        if [ ${window} = ${active_window} ] ;then
            new_active_window=${inum}
        fi
        inum=$((${inum}+1))
    done
    tmux select-window -t ${session}:${new_active_window}
done
