local languages = {
	lua = {
		require("efmls-configs.formatters.stylua"),
		require("efmls-configs.linters.luacheck"),
	},
}

return {
	init_options = {
		documentFormatting = true,
		documentRangeFormatting = true,
		hover = true,
		documentSymbol = true,
		codeAction = true,
		completion = true,
	},
	filetypes = vim.tbl_keys(languages),
	settings = {
		languages = languages,
	},
}
