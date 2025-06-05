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
    keys = {
      { '<C-,>', '<cmd>ClaudeCode<cr>', desc = 'Claude Codeをトグル' },
      { '<leader>cc', '<cmd>ClaudeCode<cr>', desc = 'Claude Codeを開く' },
      { '<leader>cC', '<cmd>ClaudeCodeContinue<cr>', desc = 'Claude Code会話を継続' },
      { '<leader>cV', '<cmd>ClaudeCodeVerbose<cr>', desc = 'Claude Code詳細モード' },
    },
    config = function()
      require('claude-code').setup({
        -- ターミナルウィンドウの設定
        terminal = {
          position = 'bottom', -- 'bottom', 'top', 'left', 'right', 'float'
          size = 15, -- ウィンドウのサイズ（行数またはパーセンテージ）
          direction = 'horizontal', -- 'horizontal' or 'vertical'
        },
        -- キーマップの設定
        keymaps = {
          toggle = '<C-,>', -- Claude Codeのトグル
          continue = '<leader>cC', -- 会話の継続
          verbose = '<leader>cV', -- 詳細モード
        },
        -- Claude Code CLIの設定
        claude_code = {
          cmd = 'claude-code', -- Claude Code CLIのコマンド
          args = {}, -- 追加の引数
        },
        -- ファイル監視の設定
        file_watcher = {
          enabled = true, -- ファイル変更の自動検出
          debounce_delay = 100, -- デバウンス遅延（ミリ秒）
        },
      })
    end,
  },
}