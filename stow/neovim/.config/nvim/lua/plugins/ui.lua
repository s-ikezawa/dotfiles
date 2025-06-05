-- UI関連プラグイン設定
return {
  -- statuscol.nvim: カスタムstatuscolumn
  {
    'luukvbaal/statuscol.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        relculright = true,
        segments = {
          { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
          { text = { "%s" }, click = "v:lua.ScSa" },
          { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa", },
        }
      })
    end,
  },

  -- Web DevIcons: ファイルタイプアイコン
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
    config = function()
      require('nvim-web-devicons').setup({
        -- グローバル設定
        default = true,
        strict = true,
        -- カスタムアイコン定義
        override = {},
        -- ファイル拡張子ベースのアイコン
        override_by_extension = {},
        -- ファイル名ベースのアイコン
        override_by_filename = {},
      })
    end,
  },

  -- Neo-tree: ファイルエクスプローラー
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    cmd = { 'Neotree' },
    keys = {
      { '<leader>e', '<cmd>Neotree toggle<cr>', desc = 'ファイルエクスプローラーをトグル' },
      { '<leader>E', '<cmd>Neotree reveal<cr>', desc = '現在のファイルをエクスプローラーで表示' },
    },
    config = function()
      -- Neo-treeをデフォルト設定で初期化
      -- https://github.com/nvim-neo-tree/neo-tree.nvim/blob/main/lua/neo-tree/defaults.lua
      require('neo-tree').setup({
        -- If a user has a sources list it will replace this one.
        -- Only sources listed here will be loaded.
        -- You can also add an external source by adding it's name to this list.
        -- The name used here must be the same name you would use in a require() call.
        sources = {
          "filesystem",
          "git_status", -- Gitステータス表示を有効化
          -- "buffers",
          -- "document_symbols",
        },
        close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
        
        -- イベントハンドラーを設定してGitステータスの更新を高速化
        event_handlers = {
          {
            event = "file_opened",
            handler = function()
              require("neo-tree.command").execute({ action = "refresh" })
            end
          },
          {
            event = "file_moved",
            handler = function()
              require("neo-tree.command").execute({ action = "refresh" })
            end
          },
          {
            event = "file_renamed",
            handler = function()
              require("neo-tree.command").execute({ action = "refresh" })
            end
          },
        },
        default_component_configs = {
          git_status = {
            symbols = {
              -- Change type
              added     = "✚", -- NOTE: you can set any of these to an empty string to not show them
              deleted   = "✖",
              modified  = "",
              renamed   = "󰁕",
              -- Status type
              untracked = "",
              ignored   = "",
              unstaged  = "",
              staged    = "",
              conflict  = "",
            },
            align = "right",
          },
        },
        filesystem = {
          -- ファイルシステム監視を有効化してGit変更を即座に反映
          follow_current_file = {
            enabled = true, -- 現在のファイルに自動的にフォーカス
            leave_dirs_open = true, -- ディレクトリを開いた状態に保つ
          },
          -- Gitステータス更新の設定
          use_libuv_file_watcher = true, -- libuv watcher使用で高速化
          scan_mode = "deep", -- ディープスキャンでGit状態を正確に取得
          
          filtered_items = {
            visible = false, -- when true, they will just be displayed differently than normal items
            force_visible_in_empty_folder = false, -- when true, hidden files will be shown if the root folder is otherwise empty
            show_hidden_count = false, -- when true, the number of hidden items in each folder will be shown as the last entry
            hide_dotfiles = false,
            hide_gitignored = true,
            hide_hidden = false, -- only works on Windows for hidden files/directories
            hide_by_name = {
              ".DS_Store",
              "thumbs.db"
              --"node_modules",
            },
            hide_by_pattern = { -- uses glob style patterns
              --"*.meta",
              --"*/src/*/tsconfig.json"
            },
            always_show = { -- remains visible even if other settings would normally hide it
              --".gitignored",
            },
            always_show_by_pattern = { -- uses glob style patterns
              --".env*",
            },
            never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
              --".DS_Store",
              --"thumbs.db"
            },
            never_show_by_pattern = { -- uses glob style patterns
              --".null-ls_*",
            },
          },
        },
        
        -- Gitステータス専用の設定
        git_status = {
          window = {
            position = "float",
            popup = {
              size = {
                height = "25%",
                width = "50%",
              },
              position = "50%",
            },
          },
        },
      })
    end,
  },

  -- which-key: キーマップヘルプ表示
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    config = function()
      local wk = require('which-key')
      wk.setup({
        -- アイコンプロバイダー設定
        icons = {
          rules = false, -- mini.iconsの代わりにカスタムアイコンを使用
        },
        -- ウィンドウ設定
        win = {
          border = 'rounded', -- none, single, double, shadow, rounded
          wo = {
            winblend = 0, -- 透明度（0-100）
          },
        },
        -- レイアウト設定
        layout = {
          height = { min = 4, max = 25 }, -- 最小/最大の行数
          width = { min = 20, max = 50 }, -- 最小/最大の列数
          spacing = 3, -- グループ間のスペース
          align = 'left', -- left, center, right
        },
        -- トリガー設定（新しいAPI）
        triggers = {
          { '<auto>', mode = 'n' }, -- ノーマルモードで自動トリガー
          { '<auto>', mode = 'v' }, -- ビジュアルモードで自動トリガー
          { '<leader>', mode = { 'n', 'v' } }, -- リーダーキーでトリガー
        },
      })

      -- キーマップの登録（新しい形式）
      wk.add({
        -- ウィンドウ操作
        { '<leader>w', group = 'ウィンドウ' },
        { '<leader>ws', '<C-w>s', desc = '水平分割' },
        { '<leader>wv', '<C-w>v', desc = '垂直分割' },
        { '<leader>wc', '<C-w>c', desc = 'ウィンドウを閉じる' },
        { '<leader>wo', '<C-w>o', desc = '他のウィンドウを閉じる' },
        { '<leader>w=', '<C-w>=', desc = 'ウィンドウサイズを均等化' },

        -- バッファ操作（init.luaで定義済み）
        { '<leader>b', group = 'バッファ' },

        -- Claude Code操作
        { '<leader>c', group = 'Claude' },
        { '<leader>cc', '<Cmd>ClaudeCode<CR>', desc = 'Claude Codeを開く' },
        { '<leader>cC', '<Cmd>ClaudeCode --continue<CR>', desc = '最新の会話を再開' },
        { '<leader>cV', '<Cmd>ClaudeCode --verbose<CR>', desc = '詳細モードで開く' },

        -- Git操作 (gitsigns)
        { '<leader>h', group = 'Git ハンク' },
        { '<leader>hs', desc = 'ハンクをステージ' },
        { '<leader>hr', desc = 'ハンクをリセット' },
        { '<leader>hS', desc = 'バッファをステージ' },
        { '<leader>hu', desc = 'ステージを取り消し' },
        { '<leader>hR', desc = 'バッファをリセット' },
        { '<leader>hp', desc = 'ハンクをプレビュー' },
        { '<leader>hb', desc = 'ライン blame' },
        { '<leader>hd', desc = 'diff を表示' },
        { '<leader>hD', desc = 'diff ~ を表示' },
        
        -- Git トグル操作
        { '<leader>t', group = 'トグル' },
        { '<leader>tb', desc = 'ライン blame をトグル' },
        { '<leader>td', desc = '削除行をトグル' },

        -- ファイルエクスプローラー（neo-treeプラグインで定義済みのため削除）
        -- { '<leader>e', '<cmd>Neotree toggle<cr>', desc = 'ファイルエクスプローラー' },
        -- { '<leader>E', '<cmd>Neotree reveal<cr>', desc = '現在のファイルを表示' },
        { '<leader>q', '<cmd>q<cr>', desc = '終了' },
        { '<leader>Q', '<cmd>qa<cr>', desc = 'すべて終了' },
        { '<leader>x', '<cmd>x<cr>', desc = '保存して終了' },
        
        -- コメント操作（Neovim 0.10のデフォルト機能）
        { 'gc', desc = 'コメント（モーション）', mode = { 'n', 'v' } },
        { 'gcc', desc = '行をコメントトグル' },
        { 'gco', desc = '下に行コメントを追加' },
        { 'gcO', desc = '上に行コメントを追加' },
      })

      -- Treesitterのテキストオブジェクト操作の説明を追加
      wk.add({
        -- 外側のテキストオブジェクト
        { 'a', group = '外側', mode = 'o' },
        { 'af', desc = 'function', mode = 'o' },
        { 'ac', desc = 'class', mode = 'o' },
        { 'aa', desc = 'parameter', mode = 'o' },
        
        -- 内側のテキストオブジェクト
        { 'i', group = '内側', mode = 'o' },
        { 'if', desc = 'function', mode = 'o' },
        { 'ic', desc = 'class', mode = 'o' },
        { 'ia', desc = 'parameter', mode = 'o' },

        -- 移動操作の説明
        { ']', group = '次へ' },
        { ']c', desc = '次のGitハンク' },
        { ']m', desc = '関数の開始' },
        { ']M', desc = '関数の終了' },
        { ']]', desc = 'クラスの開始' },
        { '][', desc = 'クラスの終了' },
        
        { '[', group = '前へ' },
        { '[c', desc = '前のGitハンク' },
        { '[m', desc = '関数の開始' },
        { '[M', desc = '関数の終了' },
        { '[[', desc = 'クラスの開始' },
        { '[]', desc = 'クラスの終了' },
      })
    end,
  },
}