-- neo-tree: ファイルをツリーで表示して開く。フローティングウィンドウで開く。
-- ツリーの中では、各ファイルの git の状態（変更・追加など）も出る。? でキーの一覧。
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add({
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range('3') }, -- v3 系のリリースを追う
  'https://github.com/nvim-lua/plenary.nvim',      -- 依存: Lua の汎用ライブラリ
  'https://github.com/MunifTanjim/nui.nvim',       -- 依存: ウィンドウなどの UI 部品
  'https://github.com/nvim-tree/nvim-web-devicons', -- ファイルの種類ごとのアイコン（which-key のアイコンにも使われる）
})

require('neo-tree').setup({
  close_if_last_window = true, -- neo-tree だけが残ったら Neovim を閉じる
  window = {
    position = 'float',        -- フローティングウィンドウで開く
  },
  filesystem = {
    follow_current_file = { enabled = true }, -- 開いているファイルの場所をツリーで選んだ状態にする
    use_libuv_file_watcher = true,            -- Claude Code などがファイルを足したり消したりしたら、ツリーを自動で更新する
    filtered_items = {
      hide_dotfiles = false,   -- 隠しファイルも出す（dotfiles を見るため）
      hide_gitignored = true,  -- .gitignore で無視されたファイルは出さない
      hide_by_name = { '.git', 'node_modules' }, -- この名前のものは出さない
    },
  },
})

vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle reveal<cr>', { desc = 'ファイルのツリーを開く・閉じる' })
vim.keymap.set('n', '<leader>ge', '<cmd>Neotree toggle git_status<cr>', { desc = '変更されたファイルの一覧を開く・閉じる' })
