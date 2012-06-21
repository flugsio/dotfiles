#!/bin/bash -e

# if vim is the active pane in tmux it will get the keystroke, else tmux will switch pane
# it may trigger a window-switch in vim, depending on current mode
# if vim is in normal mode, and window can't be changed, vim will send back a switch pane to tmux
if [[ "$(pstree $(tmux list-panes -F "#{pane_pid} #{pane_active}" | grep 1$ | cut -d " " -f 1))" == *vim* ]]; then
  tmux send-keys C-$1
else
  tmux select-pane -$2
fi
