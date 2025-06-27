return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = {
		{
			"<leader>e",
			function()
				Snacks.explorer()
			end,
			desc = "ファイルエクスプローラー",
		},
	},
	opts = {
		picker = {
			hidden = true, -- show hidden files
			ignored = true, -- show ignored files
			follow = true, -- follow symlinks
			sources = {
				explorer = {
					finder = "explorer",
					sort = { fields = { "sort" } },
					supports_live = true,
					tree = true,
					diagnostics = true,
					diagnostics_open = false,
					git_status = true,
					git_status_open = false,
					git_untracked = true,
					follow_file = true,
					focus = "list",
					auto_close = false,
					jump = { close = false },
					layout = { preset = "sidebar", preview = false },
					-- エクスプローラーを右側に表示するには
					-- opts.picker.sources.explorer の設定に以下の行を追加します。
					-- layout = { position = "right" }
					formatters = {
						file = { filename_only = true },
						severity = { pos = "right" },
					},
					matcher = { sort_empty = false, fuzzy = false },
					config = function(opts)
						return require("snacks.picker.source.explorer").setup(opts)
					end,
					win = {
						list = {
							keys = {
								["<BS>"] = "explorer_up",
								["l"] = "confirm",
								["h"] = "explorer_close", -- close directory
								["a"] = "explorer_add",
								["d"] = "explorer_del",
								["r"] = "explorer_rename",
								["c"] = "explorer_copy",
								["m"] = "explorer_move",
								["o"] = "explorer_open", -- open with system application
								["P"] = "toggle_preview",
								["y"] = { "explorer_yank", mode = { "n", "x" } },
								["p"] = "explorer_paste",
								["u"] = "explorer_update",
								["<c-c>"] = "tcd",
								["<leader>/"] = "picker_grep",
								["<c-t>"] = "terminal",
								["."] = "explorer_focus",
								["I"] = "toggle_ignored",
								["H"] = "toggle_hidden",
								["Z"] = "explorer_close_all",
								["]g"] = "explorer_git_next",
								["[g"] = "explorer_git_prev",
								["]d"] = "explorer_diagnostic_next",
								["[d"] = "explorer_diagnostic_prev",
								["]w"] = "explorer_warn_next",
								["[w"] = "explorer_warn_prev",
								["]e"] = "explorer_error_next",
								["[e"] = "explorer_error_prev",
							},
						},
					},
				},
			},
			icons = {
				files = {
					enabled = true, -- show file icons
					dir = "󰉋 ",
					dir_open = "󰝰 ",
					file = "󰈔 ",
				},
				keymaps = {
					nowait = "󰓅 ",
				},
				tree = {
					vertical = "│ ",
					middle = "├╴",
					last = "└╴",
				},
				undo = {
					saved = " ",
				},
				ui = {
					live = "󰐰 ",
					hidden = "h",
					ignored = "i",
					follow = "f",
					selected = "● ",
					unselected = "○ ",
					-- selected = " ",
				},
				git = {
					enabled = true, -- show git icons
					commit = "󰜘 ", -- used by git log
					staged = "●", -- staged changes. always overrides the type icons
					added = "",
					deleted = "",
					ignored = " ",
					modified = "○",
					renamed = "",
					unmerged = " ",
					untracked = "?",
				},
				diagnostics = {
					Error = " ",
					Warn = " ",
					Hint = " ",
					Info = " ",
				},
				lsp = {
					unavailable = "",
					enabled = " ",
					disabled = " ",
					attached = "󰖩 ",
				},
				kinds = {
					Array = " ",
					Boolean = "󰨙 ",
					Class = " ",
					Color = " ",
					Control = " ",
					Collapsed = " ",
					Constant = "󰏿 ",
					Constructor = " ",
					Copilot = " ",
					Enum = " ",
					EnumMember = " ",
					Event = " ",
					Field = " ",
					File = " ",
					Folder = " ",
					Function = "󰊕 ",
					Interface = " ",
					Key = " ",
					Keyword = " ",
					Method = "󰊕 ",
					Module = " ",
					Namespace = "󰦮 ",
					Null = " ",
					Number = "󰎠 ",
					Object = " ",
					Operator = " ",
					Package = " ",
					Property = " ",
					Reference = " ",
					Snippet = "󱄽 ",
					String = " ",
					Struct = "󰆼 ",
					Text = " ",
					TypeParameter = " ",
					Unit = " ",
					Unknown = " ",
					Value = " ",
					Variable = "󰀫 ",
				},
			},
		},
		explorer = {
			replace_netrw = true,
		},
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
		},
	},
}
