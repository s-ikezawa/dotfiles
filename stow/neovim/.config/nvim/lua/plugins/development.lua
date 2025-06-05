-- 開発支援プラグイン設定
return {
  -- Git変更表示
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('gitsigns').setup({
        signs = {
          add          = { text = '+' },
          change       = { text = '~' },
          delete       = { text = '-' },
          topdelete    = { text = '‾' },
          changedelete = { text = '≃' },
          untracked    = { text = '?' },
        },
        signs_staged = {
          add          = { text = '+' },
          change       = { text = '~' },
          delete       = { text = '-' },
          topdelete    = { text = '‾' },
          changedelete = { text = '≃' },
        },
        -- ステージ済みサインを無効化
        signs_staged_enable = false,
        numhl      = false, -- 行番号のハイライト
        linehl     = false, -- 行全体のハイライト
        word_diff  = false, -- 単語単位の差分表示
        watch_gitdir = {
          follow_files = true
        },
        attach_to_untracked = true,
        current_line_blame = false, -- 現在行にblame情報を表示
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol', -- 行末に表示
          delay = 1000,
          ignore_whitespace = false,
        },
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- カスタムステータスフォーマッター
        max_file_length = 40000, -- 大きなファイルでは無効化
        preview_config = {
          -- プレビューウィンドウオプション
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        },
        -- キーマップ設定
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- ナビゲーション
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, {expr=true})

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr=true})

          -- アクション
          map('n', '<leader>hs', gs.stage_hunk, { desc = 'Stage hunk' })
          map('n', '<leader>hr', gs.reset_hunk, { desc = 'Reset hunk' })
          map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = 'Stage hunk' })
          map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = 'Reset hunk' })
          map('n', '<leader>hS', gs.stage_buffer, { desc = 'Stage buffer' })
          map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
          map('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset buffer' })
          map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview hunk' })
          map('n', '<leader>hb', function() gs.blame_line{full=true} end, { desc = 'Blame line' })
          map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'Toggle line blame' })
          map('n', '<leader>hd', gs.diffthis, { desc = 'Diff this' })
          map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = 'Diff this ~' })
          map('n', '<leader>td', gs.toggle_deleted, { desc = 'Toggle deleted' })

          -- テキストオブジェクト
          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select hunk' })
        end
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