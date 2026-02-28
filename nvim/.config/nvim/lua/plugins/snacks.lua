vim.pack.add({
  "https://github.com/folke/snacks.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

local Snacks = require("snacks")
Snacks.setup({
  explorer = {
    enabled = true,
  },
  lazygit = {
    enabled = true,
    theme = {
      selectedLineBgColor = { bg = "CursorLine" },
    },
    win = {
      width = 0,
      height = 0,
    },
  },
  picker = {
    actions = {
      sidekick_send = function(...)
        return require("sidekick.cli.picker.snacks").send(...)
      end,
    },
    win = {
      input = {
        keys = {
          ["<a-a>"] = {
            "sidekick_send",
            mode = { "n", "i" },
          },
        },
      },
    },
    sources = {
      explorer = {
        hidden = true,
        transform = function(item)
          item.hidden = false
        end,
      },
    },
  },
  statuscolumn = {
    enabled = true,
    left = { "mark", "sign" },
    right = { "fold", "git" },
    folds = {
      open = false,
      git_hl = false,
    },
    git = {
      patterns = { "GitSign", "MiniDiffSign" },
    },
  },
})

-- スマートファイル検索 (バッファ + 最近のファイル + Git/ファイル を統合)
local function smart_files()
  local sources = require("snacks.picker.config.sources")
  local root = require("snacks.git").get_root()

  local files = root == nil and sources.files
    or vim.tbl_deep_extend("force", sources.git_files, {
      untracked = true,
      cwd = vim.uv.cwd(),
    })

  Snacks.picker({
    multi = { "buffers", "recent", files },
    format = "file",
    matcher = { frecency = true, sort_empty = true },
    filter = { cwd = true },
    transform = "unique_file",
  })
end

-- ファイル / Picker
vim.keymap.set("n", "<Leader>fb", function() Snacks.picker.buffers() end, { desc = "バッファ一覧" })
vim.keymap.set("n", "<Leader>fc", function() Snacks.picker.command_history() end, { desc = "コマンド履歴" })
vim.keymap.set("n", "<Leader>fd", function() Snacks.picker.diagnostics() end, { desc = "診断一覧" })
vim.keymap.set("n", "<Leader>fe", function() Snacks.explorer() end, { desc = "ファイルエクスプローラー" })
vim.keymap.set("n", "<Leader>ff", smart_files, { desc = "スマートファイル検索" })
vim.keymap.set("n", "<Leader>fF", function() Snacks.picker.files() end, { desc = "ファイルを検索 (全件)" })
vim.keymap.set("n", "<Leader>fg", function() Snacks.picker.grep() end, { desc = "Grep 検索" })
vim.keymap.set("n", "<Leader>fh", function() Snacks.picker.help() end, { desc = "ヘルプタグ検索" })
vim.keymap.set("n", "<Leader>fk", function() Snacks.picker.keymaps() end, { desc = "キーマップ一覧" })
vim.keymap.set("n", "<Leader>fr", function() Snacks.picker.recent() end, { desc = "最近開いたファイル" })
vim.keymap.set("n", "<Leader>fw", function() Snacks.picker.grep_word() end, { desc = "カーソル下の単語を Grep" })

-- Git
vim.keymap.set("n", "<Leader>gb", function() Snacks.picker.git_branches() end, { desc = "ブランチ一覧" })
vim.keymap.set("n", "<Leader>gf", function() Snacks.picker.git_log_file() end, { desc = "現在のファイルのコミットログ" })
vim.keymap.set("n", "<Leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
vim.keymap.set("n", "<Leader>gl", function() Snacks.picker.git_log() end, { desc = "コミットログ" })
vim.keymap.set("n", "<Leader>gL", function() Snacks.lazygit.log() end, { desc = "Lazygit ログ (リポジトリ)" })
vim.keymap.set("n", "<Leader>gs", function() Snacks.picker.git_status() end, { desc = "Git ステータス" })
