local config = function()
	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"lua",
			"go",
			"gomod",
			"gosum",
			"gowork",
			"markdown",
			"markdown_inline",
		},
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		},
		endwise = { -- nvim-treesitter-endwise
			enable = true,
		},
		autotag = { -- nvim-ts-autotag
			enable = true,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<C-space>",
				node_incremental = "<C-space>",
				scope_incremental = false,
				node_decremental = "<BS>",
			},
		},
	})
end

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-textobjects" },
		{ "RRethy/nvim-treesitter-endwise" },
		{ "windwp/nvim-ts-autotag" },
	},
	config = config,
}
