#!/bin/sh
tmux new-session \; \
 send-keys 'cd ~/currentWork; ll' C-m \; \
 split-window -h -p 50 \; \
 send-keys 'll' C-m \; \
 split-window -v \; \
 select-pane -t 0 \;
