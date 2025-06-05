-- Treesitter: シンタックスハイライトと構文解析
return {
  -- nvim-treesitter: 高度なシンタックスハイライト
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      require('nvim-treesitter.configs').setup({
        -- インストールする言語パーサー
        ensure_installed = {
          'lua',
          'vim',
          'vimdoc',
          'query',
          'javascript',
          'typescript',
          'tsx',
          'html',
          'css',
          'json',
          'yaml',
          'toml',
          'markdown',
          'markdown_inline',
          'bash',
          'python',
          'rust',
          'go',
          'dockerfile',
          'gitignore',
        },

        -- 言語パーサーの自動インストール
        auto_install = true,

        -- ハイライト設定
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },

        -- インデント設定
        indent = {
          enable = true,
        },

        -- テキストオブジェクト設定
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- 次のテキストオブジェクトを自動的に選択
            keymaps = {
              -- 関数
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              -- クラス
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              -- パラメータ
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- ジャンプリストに追加
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
}