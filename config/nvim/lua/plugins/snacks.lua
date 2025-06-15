return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	config = function()
		local Snacks = require("snacks")

		-- ハイライトグループを検索するコマンド:
		-- :lua Snacks.picker.highlights({pattern = "hl_group:^Snacks"})

		Snacks.setup({
			bigfile = { enabled = true },
			dashboard = { enabled = false },
			explorer = {
				enabled = true,
				replace_netrw = true,
			},
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
						git_status_open = true, -- 開いているディレクトリの再帰的Gitステータスを表示
						diagnostics = true,
						diagnostics_open = false,
						watch = true,
						follow_file = true,
						focus = "list",
						auto_close = false,
						auto_refresh = 50, -- より頻繁にリフレッシュ
						layout = { preset = "sidebar", preview = false },
						formatters = {
							file = {
								filename_only = true,
								icon_width = 3, -- アイコンの幅を3文字に設定（デフォルトは2）
							},
							severity = { pos = "right" },
						},
						exclude = { ".DS_Store" },
						include = { "*.backup" }, -- .backupファイルを明示的に含める
						-- Git状態更新を強制するための追加設定
						refresh_git_status = true,
						show_ignored = false, -- 通常時は無視ファイルを非表示
						-- キーマップの追加
						win = {
							list = {
								keys = {
									["<F5>"] = {
										function(picker)
											-- Gitステータスを強制的に更新
											vim.cmd("!git status")
											vim.defer_fn(function()
												picker:refresh()
											end, 100)
										end,
										desc = "Gitステータスを強制更新",
									},
								},
							},
						},
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
				sign = {
					patterns = { "Diagnostic" }, -- 診断サインのパターンを追加
				},
				refresh = 100, -- リフレッシュ間隔(ms)
			},
			words = { enabled = true },
		})

		-- keymaps
		local keymap = vim.keymap
		-- Explorer
		keymap.set("n", "<leader>ee", function()
			Snacks.explorer()
		end, { desc = "ファイルエクスプローラーをトグル" })
		keymap.set("n", "<leader>ef", function()
			Snacks.explorer({ reveal = true })
		end, { desc = "現在のファイルをエクスプローラーで表示" })
		keymap.set("n", "<leader>er", function()
			-- Explorer Git状態の手動リフレッシュ
			local gitsigns = require("gitsigns")
			gitsigns.refresh()

			-- Snacksのピッカーが開いている場合は一度閉じて再度開く
			local picker = Snacks.picker.get()
			if picker and picker.opts and picker.opts.finder == "explorer" then
				-- 現在のパスを保存
				local current_file = vim.api.nvim_buf_get_name(0)
				-- explorerを閉じる
				picker:close()
				-- 少し待機してから再度開く
				vim.defer_fn(function()
					Snacks.explorer({ reveal = true, file = current_file })
				end, 100)
			else
				-- explorerが開いていない場合は通常のリフレッシュ
				vim.cmd("checktime")
			end

			vim.notify("Explorer and Git signs refreshed", "info")
		end, { desc = "エクスプローラーとGitサインを手動リフレッシュ" })
		-- Picker
		keymap.set("n", "<leader>ff", function()
			Snacks.picker.files()
		end, { desc = "ファイル検索" })
		keymap.set("n", "<leader>fg", function()
			Snacks.picker.git_files()
		end, { desc = "Gitファイル検索" })
		keymap.set("n", "<leader>fb", function()
			Snacks.picker.buffers()
		end, { desc = "バッファ一覧を表示" })
	end,
}
