#!/bin/bash
# tmux-agent-state.sh — Set agent state per-pane, render dots per-window.
# Usage:
#   tmux-agent-state.sh set thinking|needs_input|done
#   tmux-agent-state.sh clear
#   tmux-agent-state.sh clear-done [window_id]
#   tmux-agent-state.sh focus-pane [pane_id]

set -euo pipefail

# Bail out if not inside tmux
[ -n "${TMUX:-}" ] || exit 0

action="${1:-}"
shift || true

# --- helpers ---

# Check if a pane is running a shell (i.e., no agent active — state is stale)
is_shell() {
  local cmd
  cmd=$(tmux display-message -p -t "$1" '#{pane_current_command}')
  case "$cmd" in
    bash|zsh|sh|fish|dash) return 0 ;;
    *) return 1 ;;
  esac
}

# Clear a pane's state if it's done or stale (shell with no agent)
clear_if_inactive() {
  local pane_id="$1"
  local state
  state=$(tmux show-options -pqv -t "$pane_id" @agent_state 2>/dev/null || true)
  [ -z "$state" ] && return
  if [ "$state" = "done" ] || is_shell "$pane_id"; then
    tmux set-option -pu -t "$pane_id" @agent_state
  fi
}

render_window_icons() {
  local win="$1"
  local icons=""
  # List all panes in this window and read their @agent_state
  while IFS= read -r pane_id; do
    state=$(tmux show-options -pqv -t "$pane_id" @agent_state 2>/dev/null || true)
    case "$state" in
      thinking)    icons+="#[fg=#D77757,bold]●" ;;
      needs_input) icons+="#[fg=#ffcc00,bold]●" ;;
      done)        icons+="#[fg=#2ecc71,bold]●" ;;
    esac
  done < <(tmux list-panes -t "$win" -F '#{pane_id}')

  # no trailing space — format string handles spacing

  tmux set-option -w -t "$win" @agent_icons "$icons"
  tmux refresh-client -S
}

# --- commands ---

case "$action" in
  set)
    state="${1:-}"
    [ -z "$state" ] && { echo "Usage: tmux-agent-state.sh set <state>" >&2; exit 1; }

    pane="$TMUX_PANE"
    win=$(tmux display-message -p -t "$pane" '#{window_id}')

    tmux set-option -p -t "$pane" @agent_state "$state"
    render_window_icons "$win"
    ;;

  clear)
    pane="$TMUX_PANE"
    win=$(tmux display-message -p -t "$pane" '#{window_id}')

    tmux set-option -pu -t "$pane" @agent_state
    render_window_icons "$win"
    ;;

  clear-done)
    # Called by after-select-window: clean up all done/stale panes in window
    win="${1:-$(tmux display-message -p '#{window_id}')}"
    while IFS= read -r pane_id; do
      clear_if_inactive "$pane_id"
    done < <(tmux list-panes -t "$win" -F '#{pane_id}')
    render_window_icons "$win"
    ;;

  focus-pane)
    # Called by after-select-pane: clean up the focused pane if done/stale
    pane="${1:-$(tmux display-message -p '#{pane_id}')}"
    win=$(tmux display-message -p -t "$pane" '#{window_id}')
    clear_if_inactive "$pane"
    render_window_icons "$win"
    ;;

  *)
    echo "Usage: tmux-agent-state.sh {set|clear|clear-done|focus-pane}" >&2
    exit 1
    ;;
esac
