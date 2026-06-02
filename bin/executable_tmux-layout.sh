#!/usr/bin/env bash
set -euo pipefail

SESSION="${1:-work}"

if tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux attach -t "$SESSION"
  exit 0
fi

# 実端末サイズでセッションを作る（-d だと 80x24 になり 1/3 計算が狂うため）
tmux new-session -d -s "$SESSION" -n main -c "$HOME/projects" \
  -x "$(tput cols)" -y "$(tput lines)"
main_pane=$(tmux display-message -p -t "$SESSION" '#{pane_id}')

# 1) 右に列を作り、幅をウィンドウの1/3に（割合指定なので再配分されても維持される）
right_pane=$(tmux split-window -h -t "$main_pane" -l '33%' -c "$HOME/projects" -P -F '#{pane_id}')

# 2) 右列を上下分割し、下の高さを右列の1/3に
right_bottom=$(tmux split-window -v -t "$right_pane" -l '33%' -c "$HOME" -P -F '#{pane_id}')

# コマンド起動
# tmux send-keys -t "$main_pane"    "claude" C-m
# tmux send-keys -t "$right_pane"   "watch -n 5 git -C ~/projects status -s" C-m
# tmux send-keys -t "$right_bottom" "btop" C-m

tmux select-pane -t "$main_pane"
tmux attach -t "$SESSION"
