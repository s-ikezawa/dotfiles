return {
	"nvim-tree/nvim-tree.lua",
	lazy = false,
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
	},
	config = function()
		require("nvim-tree").setup({
			sort = {
				sorter = "case_sensitive",
			},
			view = {
				width = 35,
			},
			renderer = {
				group_empty = true,
			},
			filters = {
				dotfiles = false,
			},
		})
	end,
}
