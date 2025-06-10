return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("gitsigns").setup({
            -- デフォルト: add = "│", change = "│", delete = "_", topdelete = "‾", changedelete = "~", untracked = "┆"
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "-" },
                topdelete = { text = "‾" },
                changedelete = { text = "≃" },
                untracked = { text = "?" },
            },
            -- デフォルト（staged）: add = "┃", change = "┃", delete = "_", topdelete = "‾", changedelete = "~", untracked = "┆"
            signs_staged = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "-" },
                topdelete = { text = "‾" },
                changedelete = { text = "≃" },
                untracked = { text = "?" },
            },
            signcolumn = true,
            numhl = false,
            linehl = false,
            word_diff = false,
            watch_gitdir = {
                interval = 1000,
                follow_files = true,
            },
            attach_to_untracked = true,
            current_line_blame = false,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol",
                delay = 1000,
                ignore_whitespace = false,
            },
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil,
            max_file_length = 40000,
            preview_config = {
                border = "single",
                style = "minimal",
                relative = "cursor",
                row = 0,
                col = 1,
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- ナビゲーション
                map("n", "]c", function()
                    if vim.wo.diff then return "]c" end
                    vim.schedule(function() gs.next_hunk() end)
                    return "<Ignore>"
                end, { expr = true, desc = "次の変更箇所" })

                map("n", "[c", function()
                    if vim.wo.diff then return "[c" end
                    vim.schedule(function() gs.prev_hunk() end)
                    return "<Ignore>"
                end, { expr = true, desc = "前の変更箇所" })

                -- アクション
                map("n", "<leader>hs", gs.stage_hunk, { desc = "変更箇所をステージ" })
                map("n", "<leader>hr", gs.reset_hunk, { desc = "変更箇所をリセット" })
                map("v", "<leader>hs", function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end, { desc = "選択範囲をステージ" })
                map("v", "<leader>hr", function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end, { desc = "選択範囲をリセット" })
                map("n", "<leader>hS", gs.stage_buffer, { desc = "バッファ全体をステージ" })
                map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "ステージを取り消し" })
                map("n", "<leader>hR", gs.reset_buffer, { desc = "バッファ全体をリセット" })
                map("n", "<leader>hp", gs.preview_hunk, { desc = "変更箇所をプレビュー" })
                map("n", "<leader>hb", function() gs.blame_line{ full = true } end, { desc = "行のBlame情報を表示" })
                map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "行のBlame表示をトグル" })
                map("n", "<leader>hd", gs.diffthis, { desc = "差分表示" })
                map("n", "<leader>hD", function() gs.diffthis("~") end, { desc = "HEADとの差分表示" })
                map("n", "<leader>td", gs.toggle_deleted, { desc = "削除行の表示をトグル" })

                -- テキストオブジェクト
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "変更箇所を選択" })
            end,
        })
    end,
}
