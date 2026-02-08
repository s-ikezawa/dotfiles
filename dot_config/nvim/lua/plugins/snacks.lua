vim.pack.add({
  {
    src = "https://github.com/folke/snacks.nvim",
  },
})

local Snacks = require("snacks")
local excludes = {
  "**/.git/*",
  "**/node_modules/*",
  "**/.yarn/cache/*",
  "**/.yarn/install*",
  "**/.yarn/releases/*",
  "**/.pnpm-store/*",
  "**/.idea/*",
}
Snacks.setup({
  bigfile = { enabled = false },
  dashboard = { enabled = false },
  explorer = { enabled = true },
  indent = { enabled = false },
  input = { enabled = false },
  picker = {
    enabled = true,
    sources = {
      files = {
        hidden = true,
        ignored = true,
        win = {
          input = {
            keys = {
              ["<s-h>"] = "Toggle Hidden",
              ["<s-i>"] = "Toggle Ignored",
              ["<s-f>"] = "Toggle Follow",
              ["<c-y>"] = { "yazi_copy_relative_path", mode = { "n", "i" } },
            },
          },
        },
        exclude = excludes,
      },
      grep = {
        hidden = true,
        ignore = true,
        win = {
          input = {
            keys = {
              ["<s-h>"] = "Toggle Hidden",
              ["<s-i>"] = "Toggle Ignored",
              ["<s-f>"] = "Toggle Follow",
            },
          },
        },
        exclude = excludes,
      },
      explorer = {
        hidden = true,
        ignored = true,
        supports_live = true,
        auto_close = true,
        diagnostics = true,
        diagnostics_open = false,
        focus = "list",
        follow_file = true,
        git_status = true,
        git_status_open = false,
        git_untracked = true,
        jump = { close = true },
        tree = true,
        watch = true,
        exclude = {
          ".git",
          ".DS_Store",
        },
      },
    },
  },
  notifier = { enabled = false },
  quickfile = { enabled = false },
  scope = { enabled = false },
  scroll = { enabled = false },
  statuscolumn = { enabled = true },
  words = { enabled = false },
})

local keymaps = {
  -- File/Find
  {
    "<leader>fb",
    function()
      Snacks.picker.buffers()
    end,
    desc = "バッファーを検索",
  },
  {
    "<leader>fe",
    function()
      Snacks.explorer()
    end,
    desc = "ファイルエクスプローラー",
  },
  {
    "<leader>ff",
    function()
      Snacks.picker.files()
    end,
    desc = "ファイルを検索",
  },
  -- LSP
  {
    "gd",
    function()
      Snacks.picker.lsp_definitions()
    end,
    desc = "定義へジャンプ",
  },
  {
    "gD",
    function()
      Snacks.picker.lsp_declarations()
    end,
    desc = "宣言へジャンプ",
  },
  {
    "gr",
    function()
      Snacks.picker.lsp_references()
    end,
    desc = "参照一覧を表示",
  },
  {
    "gI",
    function()
      Snacks.picker.lsp_implementations()
    end,
    desc = "実装へジャンプ",
  },
  {
    "gy",
    function()
      Snacks.picker.lsp_type_definitions()
    end,
    desc = "型定義へジャンプ",
  },
  {
    "<leader>ss",
    function()
      Snacks.picker.lsp_symbols()
    end,
    desc = "バッファーのシンボル一覧を表示",
  },
  {
    "<leader>sS",
    function()
      Snacks.picker.lsp_workspace_symbols()
    end,
    desc = "ワークスペースのシンボル一覧を表示",
  },
  {
    "gai",
    function()
      Snacks.picker.lsp_incoming_calls()
    end,
    desc = "関数を呼び出している箇所の一覧を表示",
    has = "callHierarchy/incomingCalls",
  },
  {
    "gao",
    function()
      Snacks.picker.lsp_outgoing_calls()
    end,
    desc = "カーソルがある関数で呼び出している関数の一覧を表示",
    has = "callHierarchy/outgoingCalls",
  },
  -- Search
  {
    "<leader>sd",
    function()
      Snacks.picker.diagnostics()
    end,
    desc = "診断結果一覧を表示",
  },
  {
    "<leader>sD",
    function()
      Snacks.picker.diagnostics_buffer()
    end,
    desc = "バッファー内の診断結果一覧を表示",
  },
  {
    "<leader>sk",
    function()
      Snacks.picker.keymaps()
    end,
    desc = "キーマップ一覧を表示",
  },
}

for _, map in ipairs(keymaps) do
  local opts = { desc = map.desc }

  if map.silent ~= nil then
    opts.silent = map.silent
  end

  if map.noremap ~= nil then
    opts.noremap = map.noremap
  else
    opts.noremap = true
  end

  if map.expr ~= nil then
    opts.expr = map.expr
  end

  local mode = map.mode or "n"
  vim.keymap.set(mode, map[1], map[2], opts)
end
