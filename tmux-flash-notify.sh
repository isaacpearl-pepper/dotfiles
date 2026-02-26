#!/bin/bash
# Show static notification glyph on tmux tab until killed by next hook.

win=${1:-$(tmux display-message -p -t "$TMUX_PANE" '#{window_id}')}
pidfile="/tmp/claude-tmux-flash-${win}.pid"
[ -f "$pidfile" ] && kill "$(cat "$pidfile")" 2>/dev/null
echo $$ > "$pidfile"

glyph="󱜸"
color="#ffcc00"

cur_reset='#[fg=white,bg=#1F2335]   #I #W  '
inact_reset='#[fg=brightwhite,bg=default,nobold,noitalics,nounderscore]   #I #W #F  '

set_fmt() {
  tmux setw -t "$win" window-status-current-format "$1"
  tmux setw -t "$win" window-status-format "$2"
}

cleanup() { set_fmt "$cur_reset" "$inact_reset" 2>/dev/null; rm -f "$pidfile"; }
trap cleanup EXIT

set_fmt "#[fg=${color},bg=#1F2335,bold] ${glyph} #[fg=white]#I #W  " "#[fg=${color},bg=default,bold] ${glyph} #[fg=brightwhite,nobold]#I #W #F  "

while true; do sleep 1; done
