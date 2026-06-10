-- ~/.config/nvim/lua/plugins/sidekick.lua
-- Sidekick (AI CLI: Claude Code)

require("sidekick").setup({
  nes = {
    enabled = false, -- Copilot の Next Edit Suggestions を無効にする(CLI のみ利用)
  },
  cli = {
    tools = {
      -- Claude Code 2.x は既定で「代替画面(alternate screen)」を使うため、
      -- 出力が tmux のスクロールバック履歴に残らない(vim/htop 等と同じ)。
      -- その結果 <C-q> でノーマルモードに入っても、sidekick がダンプできるのは
      -- 表示中の画面だけで、過去の出力へスクロール/コピーできない。
      -- 代替画面を無効化すると出力が通常バッファに残り、tmux/Neovim の
      -- スクロールバックが復活して <C-q> でのスクロール・コピーが使えるようになる。
      claude = {
        env = { CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN = "1" },
      },
    },
    mux = {
      backend = "tmux", -- tmux セッションで CLI を永続化(Neovim を閉じても残る)
      enabled = true,   -- tmux 内で Neovim を使っているので有効化
      -- create = "terminal" のまま: tmux で永続化しつつ表示は Neovim のターミナル split
    },
    win = {
      split = {
        width = 100, -- Claude Code を開いたときの幅(デフォルト 80)
      },
      -- ターミナル内のウィンドウ/ペイン移動。
      -- sidekick 標準の nav_* アクションは「Neovim の端では <c-j> 等を CLI へ素通し」
      -- してしまう(actions.lua の at_edge 判定)。そのため下に tmux ペインがあっても
      -- TmuxNavigate が呼ばれず移動できない。
      -- ここで nav_* キーを直接 TmuxNavigate* に差し替えて sidekick の端判定を回避する。
      -- 端判定(nvim split かそれとも tmux ペインか)は vim-tmux-navigator 側が行う。
      -- ※ デフォルトの nav_* は expr=true なので、上書き時に expr=false で打ち消すこと
      --   (expr のままだと関数の戻り値がキー列として扱われ wincmd が効かない)。
      keys = {
        nav_left  = { "<c-h>", function() vim.cmd("TmuxNavigateLeft")  end, mode = "nt", expr = false, desc = "左のウィンドウ/ペインへ移動" },
        nav_down  = { "<c-j>", function() vim.cmd("TmuxNavigateDown")  end, mode = "nt", expr = false, desc = "下のウィンドウ/ペインへ移動" },
        nav_up    = { "<c-k>", function() vim.cmd("TmuxNavigateUp")    end, mode = "nt", expr = false, desc = "上のウィンドウ/ペインへ移動" },
        nav_right = { "<c-l>", function() vim.cmd("TmuxNavigateRight") end, mode = "nt", expr = false, desc = "右のウィンドウ/ペインへ移動" },
      },
    },
  },
})

-- Claude Code CLI のキーマップ
local map = vim.keymap.set
map({ "n", "x" }, "<leader>aa", function() require("sidekick.cli").toggle({ name = "claude" }) end, { desc = "Claude CLI トグル" })
map({ "n", "x" }, "<leader>ap", function() require("sidekick.cli").prompt() end, { desc = "プロンプト選択" })
map("x", "<leader>as", function() require("sidekick.cli").send({ msg = "{selection}" }) end, { desc = "選択範囲を Claude に送信" })
-- ファイル名・行数などの位置情報を Claude のプロンプトに挿入する。
-- {file}     -> @path/to/file
-- {line}     -> @path/to/file :L42   (visual では行範囲)
-- {position} -> @path/to/file :L42:C5 (visual では選択範囲)
-- submit せず挿入だけ行い、続けて質問を入力できるようにする。
map({ "n", "x" }, "<leader>af", function() require("sidekick.cli").send({ msg = "{file}" }) end, { desc = "ファイル名を Claude に渡す" })
map({ "n", "x" }, "<leader>al", function() require("sidekick.cli").send({ msg = "{line}" }) end, { desc = "ファイル名+行を Claude に渡す" })
map({ "n", "x" }, "<leader>ac", function() require("sidekick.cli").send({ msg = "{position}" }) end, { desc = "ファイル名+行:列を Claude に渡す" })
