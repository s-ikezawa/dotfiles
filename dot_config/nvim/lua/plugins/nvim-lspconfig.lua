local config = function()
	local servers = {
		"efm",
		"lua_ls",
	}

	-- neoconfはlspconfigより先にsetupする必要がある
	require("neoconf").setup({})
	local lspconfig = require("lspconfig")

	local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end

	-- LSP Install
	require("mason-lspconfig").setup({
		ensure_installed = servers,
		automatic_installation = true,
	})

	require("lspsaga").setup({})

	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	for _, server in pairs(servers) do
		local server_settings = {
			capabilities = capabilities,
			on_attach = require("util.lsp").on_attach,
		}

		local ok, settings = pcall(require, "lsp." .. server)
		if ok then
			server_settings = vim.tbl_deep_extend("force", settings, server_settings)
		end

		lspconfig[server].setup(server_settings)
	end
end

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "creativenull/efmls-configs-nvim" },
		{ "nvimdev/lspsaga.nvim" },
		{ "folke/neoconf.nvim" },
	},
	config = config,
}
