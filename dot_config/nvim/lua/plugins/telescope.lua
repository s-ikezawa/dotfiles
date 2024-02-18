local keymap = vim.keymap
local config = function()
	local telescope = require("telescope")
	local actions = require("telescope.actions")
	telescope.setup({
		defaults = {
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--hidden",
				"--glob=!.git/",
			},
			mappings = {
				i = {
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
				},
			},
		},
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			},
		},
	})
	telescope.load_extension("fzf")
	telescope.load_extension("kensaku")
end

return {
	"nvim-telescope/telescope.nvim",
	lazy = false,
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "Allianaab2m/telescope-kensaku.nvim" },
	},
	keys = {
		keymap.set("n", "<leader>fk", ":Telescope keymaps<CR>", { desc = "[F]uzzy find [K]eymaps" }),
		keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "[F]uzzy find [H]elp tags" }),
		keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "[F]uzzy find [F]iles" }),
		keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "[F]uzzy find [G]rep result" }),
		keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "[F]uzzy find [B]uffers" }),
	},
	config = config,
}
