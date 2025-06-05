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