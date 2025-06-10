return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function()
        local Snacks = require("snacks")

        -- VSCode風のGitステータスカラー設定
        -- ハイライトグループを検索するコマンド:
        -- :lua Snacks.picker.highlights({pattern = "hl_group:^Snacks"})
        vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { fg = "#73C991" }) -- 緑色
        vim.api.nvim_set_hl(0, "SnacksPickerGitStatusAdded", { fg = "#73C991" }) -- 緑色
        vim.api.nvim_set_hl(0, "SnacksPickerGitStatusModified", { fg = "#E2C08D" }) -- 黄色
        vim.api.nvim_set_hl(0, "SnacksPickerGitStatusDeleted", { fg = "#F44747" }) -- 赤色
        vim.api.nvim_set_hl(0, "SnacksPickerGitStatusRenamed", { fg = "#73C991" }) -- 緑色
        vim.api.nvim_set_hl(0, "SnacksPickerGitStatusCopied", { fg = "#73C991" }) -- 緑色
        vim.api.nvim_set_hl(0, "SnacksPickerGitStatusStaged", { fg = "#73C991" }) -- 緑色
        vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUnmerged", { fg = "#F44747" }) -- 赤色
        vim.api.nvim_set_hl(0, "SnacksPickerGitStatusIgnored", { fg = "#848484" }) -- グレー

        Snacks.setup({
            bigfile = { enabled = true },
            dashboard = { enabled = false },
            explorer = { enabled = true },
            image = { enabled = true },
            indent = {
                enabled = true,
            },
            input = { enabled = true },
            notifier = { enabled = true },
            picker = {
                enabled = true,
                hidden = true, -- 隠しファイルの表示
                sources = {
                    explorer = {
                        finder = "explorer",
                        tree = true,
                        git_status = true,
                        git_untracked = true,
                        git_status_open = false,
                        diagnostics = true,
                        diagnostics_open = false,
                        watch = true,
                        follow_file = true,
                        focus = "list",
                        auto_close = false,
                        layout = { preset = "sidebar", preview = false },
                        formatters = {
                            file = { filename_only = true },
                            severity = { pos = "right" },
                        },
                        exclude = { ".DS_Store" },
                    },
                },
            },
            quickfile = { enabled = true },
            scope = { enabled = false },
            scroll = { enabled = true },
            statuscolumn = { 
                enabled = true,
                left = { "mark", "sign" }, -- 左側: マークとサイン
                right = { "fold", "git" }, -- 右側: フォールドとGit情報
                folds = {
                    open = true, -- オープンフォールドを表示
                    git_hl = false, -- Gitハイライトを無効
                },
                git = {
                    patterns = { "GitSign", "MiniDiffSign" }, -- Git関連のサイン
                },
                refresh = 50, -- リフレッシュ間隔(ms)
            },
            words = { enabled = true },
        })

        -- keymaps
        local keymap = vim.keymap
        -- Explorer
        keymap.set("n", "<leader>ee", function() Snacks.explorer() end, { desc = "ファイルエクスプローラーをトグル" })
        keymap.set("n", "<leader>ef", function() Snacks.explorer({ reveal = true }) end, { desc = "現在のファイルをエクスプローラーで表示" })
        -- Picker
        keymap.set("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "ファイル検索" })
        keymap.set("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Gitファイル検索" })
        keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "バッファ一覧を表示" })
    end,
}
