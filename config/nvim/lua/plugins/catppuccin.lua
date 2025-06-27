return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup {
			flavour = "mocha",
			custom_highlights = function()
				return {
					-- VSCode風のGitステータスカラー設定
					SnacksPickerGitStatusUntracked = { fg = "#73C991" }, -- 緑色
					SnacksPickerGitStatusAdded = { fg = "#73C991" }, -- 緑色
					SnacksPickerGitStatusModified = { fg = "#E2C08D" }, -- 黄色
					SnacksPickerGitStatusDeleted = { fg = "#F44747" }, -- 赤色
					SnacksPickerGitStatusRenamed = { fg = "#73C991" }, -- 緑色
					SnacksPickerGitStatusCopied = { fg = "#73C991" }, -- 緑色
					SnacksPickerGitStatusStaged = { fg = "#73C991" }, -- 緑色
					SnacksPickerGitStatusUnmerged = { fg = "#F44747" }, -- 赤色
					SnacksPickerGitStatusIgnored = { fg = "#848484" }, -- グレー
				}
			end,
		}
		vim.cmd.colorscheme "catppuccin"
	end,
}
