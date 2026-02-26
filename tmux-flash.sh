#!/bin/bash
# Flash the tmux tab with animated spinner until user input or tab switch.

pidfile="/tmp/claude-tmux-flash-${TMUX_PANE}.pid"
[ -f "$pidfile" ] && kill "$(cat "$pidfile")" 2>/dev/null
echo $$ > "$pidfile"

win=$(tmux display-message -p -t "$TMUX_PANE" '#{window_id}')
start=$(tmux display-message -p '#{client_activity}')

frames=("󰝥" "󰻃" "󱥸")
colors=("#ff0000" "#ff7700" "#ffff00" "#00ff00" "#0077ff" "#8800ff")

cur_reset='#[fg=white,bg=#1F2335]   #I #W  '
inact_reset='#[fg=brightwhite,bg=default,nobold,noitalics,nounderscore]   #I #W #F  '

set_fmt() {
  tmux setw -t "$win" window-status-current-format "$1"
  tmux setw -t "$win" window-status-format "$2"
}

cleanup() { set_fmt "$cur_reset" "$inact_reset" 2>/dev/null; rm -f "$pidfile"; }
trap cleanup EXIT

i=0
while true; do
  now=$(tmux display-message -p '#{client_activity}')
  active=$(tmux display-message -p -t "$win" '#{window_active}')
  [ "$active" = "1" ] && [ "$now" != "$start" ] && break
  [ "$active" = "0" ] && start=$now

  f=${frames[$((i % ${#frames[@]}))]}
  c=${colors[$((i % ${#colors[@]}))]}
  set_fmt "#[fg=${c},bg=#1F2335,bold] ${f} #[fg=white]#I #W  " "#[fg=${c},bg=default,bold] ${f} #[fg=brightwhite,nobold]#I #W #F  "

  i=$((i + 1))
  sleep 0.15
done
