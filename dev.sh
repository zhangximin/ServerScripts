#!/bin/sh
tmux new-session -d
tmux split-window -h -p 40
tmux split-window -v
tmux attach-session -d -t 0


