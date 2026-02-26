#!/bin/bash
# Pulse the tmux tab with Claude's thinking animation until next hook.
# Color shifts from rust/orange to red after ~20s to signal "stuck".

win=${1:-$(tmux display-message -p -t "$TMUX_PANE" '#{window_id}')}
pidfile="/tmp/claude-tmux-flash-${win}.pid"
[ -f "$pidfile" ] && kill "$(cat "$pidfile")" 2>/dev/null
echo $$ > "$pidfile"

frames=("·" "✢" "✳" "✶" "✻" "✽" "✻" "✶" "✳" "✢")

cur_reset='#[fg=white,bg=#1F2335]   #I #W  '
inact_reset='#[fg=brightwhite,bg=default,nobold,noitalics,nounderscore]   #I #W #F  '

set_fmt() {
  tmux setw -t "$win" window-status-current-format "$1"
  tmux setw -t "$win" window-status-format "$2"
}

cleanup() { set_fmt "$cur_reset" "$inact_reset" 2>/dev/null; rm -f "$pidfile"; }
trap cleanup EXIT

# Transition from #D77757 (rust) to #FF0000 (red) over iterations 133-233 (~20-35s)
get_color() {
  local i=$1
  if [ $i -lt 133 ]; then
    echo "#D77757"
  elif [ $i -lt 233 ]; then
    local t=$((i - 133))
    local r=$((215 + t * 40 / 100))
    local g=$((119 - t * 119 / 100))
    local b=$((87 - t * 87 / 100))
    printf "#%02x%02x%02x" $r $g $b
  else
    echo "#ff0000"
  fi
}

i=0
while true; do
  f=${frames[$((i % ${#frames[@]}))]}
  c=$(get_color $i)
  set_fmt "#[fg=${c},bg=#1F2335,bold] ${f} #[fg=white]#I #W  " "#[fg=${c},bg=default,bold] ${f} #[fg=brightwhite,nobold]#I #W #F  "

  i=$((i + 1))
  sleep 0.15
done
