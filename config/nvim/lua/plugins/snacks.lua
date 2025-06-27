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
					exclude = { ".DS_Store" },
					include = { "*.backup" },
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
