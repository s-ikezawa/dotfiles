-- プラグイン設定のエントリーポイント
-- このファイルは lazy.nvim によって自動的に読み込まれます

return {
  -- カラースキーム: Catppuccin
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false, -- カラースキームは即座に読み込む
    priority = 1000, -- 他のプラグインより先に読み込む
    config = function()
      require('catppuccin').setup({
        flavour = 'mocha', -- latte, frappe, macchiato, mocha
        background = {
          light = 'latte',
          dark = 'mocha',
        },
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = true,
        dim_inactive = {
          enabled = false,
          shade = 'dark',
          percentage = 0.15,
        },
        no_italic = false,
        no_bold = false,
        no_underline = false,
        styles = {
          comments = { 'italic' },
          conditionals = { 'italic' },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        integrations = {
          neotree = true,
          nvimtree = true,
          treesitter = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { 'italic' },
              hints = { 'italic' },
              warnings = { 'italic' },
              information = { 'italic' },
            },
            underlines = {
              errors = { 'underline' },
              hints = { 'underline' },
              warnings = { 'underline' },
              information = { 'underline' },
            },
            inlay_hints = {
              background = true,
            },
          },
        },
      })
      -- カラースキームを適用
      vim.cmd.colorscheme('catppuccin')
    end,
  },

  -- Treesitter: シンタックスハイライト
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      require('nvim-treesitter.configs').setup({
        -- インストールするパーサー
        ensure_installed = {
          'bash',
          'c',
          'cpp',
          'css',
          'dockerfile',
          'go',
          'html',
          'javascript',
          'json',
          'lua',
          'markdown',
          'markdown_inline',
          'python',
          'rust',
          'toml',
          'tsx',
          'typescript',
          'vim',
          'vimdoc',
          'yaml',
        },
        -- 自動インストールを有効化
        auto_install = true,
        -- シンタックスハイライトを有効化
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        -- インデントを有効化
        indent = {
          enable = true,
        },
        -- テキストオブジェクトを有効化
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
        },
      })
    end,
  },

  -- Web DevIcons: ファイルアイコン
  {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup({
        -- グローバルにアイコンを有効化
        override = {},
        -- デフォルトアイコンを設定
        default = true,
        -- 厳密モード（アイコンが見つからない場合に警告）
        strict = true,
        -- フォルダアイコンの色を統一
        override_by_filename = {
          ['.gitignore'] = {
            icon = '',
            color = '#f1502f',
            name = 'Gitignore'
          }
        },
        -- 拡張子によるアイコンのオーバーライド
        override_by_extension = {
          ['log'] = {
            icon = '',
            color = '#81e043',
            name = 'Log'
          }
        }
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
    cmd = 'Neotree',
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
          -- "buffers",
          -- "git_status",
          -- "document_symbols",
        },
        close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
        default_component_configs = {
          git_status = {
            symbols = {
              -- Change type
              added     = "✚", -- NOTE: you can set any of these to an empty string to not show them
              deleted   = "✖",
              modified  = "",
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

        -- その他
        { '<leader>e', '<cmd>Neotree toggle<cr>', desc = 'ファイルエクスプローラー' },
        { '<leader>E', '<cmd>Neotree reveal<cr>', desc = '現在のファイルを表示' },
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
        { ']m', desc = '関数の開始' },
        { ']M', desc = '関数の終了' },
        { ']]', desc = 'クラスの開始' },
        { '][', desc = 'クラスの終了' },
        
        { '[', group = '前へ' },
        { '[m', desc = '関数の開始' },
        { '[M', desc = '関数の終了' },
        { '[[', desc = 'クラスの開始' },
        { '[]', desc = 'クラスの終了' },
      })
    end,
  },

  -- Claude Code統合
  {
    'greggh/claude-code.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('claude-code').setup({
        -- コマンド設定
        command = "claude",
        -- コマンドのバリエーション
        command_variants = {
          -- 会話管理
          continue = "--continue", -- 最新の会話を再開
          resume = "--resume",     -- インタラクティブな会話選択画面を表示

          -- 出力オプション
          verbose = "--verbose",   -- ターン毎の詳細出力による詳細ログを有効化
        },
        -- ターミナルの表示位置設定
        window = {
          split_ratio = 0.3, -- ターミナルウィンドウの画面占有率（水平分割では高さ、垂直分割では幅）
          position = "rightbelow vsplit", -- ウィンドウの位置: "botright", "topleft", "vertical", "rightbelow vsplit"など
          enter_insert = true, -- Claude Code開始時にインサートモードに入るかどうか
          hide_numbers = true, -- ターミナルウィンドウで行番号を非表示
          hide_signcolumn = true, -- ターミナルウィンドウでサインカラムを非表示
        },
        -- ファイル更新設定
        refresh = {
          enable = true,           -- ファイル変更検出を有効化
          updatetime = 100,        -- Claude Code有効時のupdatetime（ミリ秒）
          timer_interval = 1000,   -- ファイル変更チェック間隔（ミリ秒）
          show_notifications = true, -- ファイルリロード時の通知表示
        },
        -- Gitプロジェクト設定
        git = {
          use_git_root = true,     -- Claude Code開始時にCWDをgitルートに設定（gitプロジェクト内の場合）
        },
        -- キーマップ
        keymaps = {
          toggle = {
            normal = "<C-,>", -- Claude Code切り替えのノーマルモードキーマップ、無効化するにはfalse
            terminal = "<C-,>", -- Claude Code切り替えのターミナルモードキーマップ、無効化するにはfalse
            variants = {
              continue = "<leader>cC", -- continueフラグ付きClaude Codeのノーマルモードキーマップ
              verbose = "<leader>cV", -- verboseフラグ付きClaude Codeのノーマルモードキーマップ
            },
          },
          window_navigation = true, -- ウィンドウナビゲーションキーマップ（<C-h/j/k/l>）を有効化
          scrolling = true, -- ページアップ/ダウンのスクロールキーマップ（<C-f/b>）を有効化
        }
      })
    end,
  },
}
