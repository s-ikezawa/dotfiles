-- Lua Language Server設定
local M = {}

M.config = {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
			format = {
				enable = true,
				defaultConfig = {
					indent_style = "space",
					indent_size = "2",
					continuation_indent_size = "2",
				},
			},
		},
	},
}

function M.setup()
	-- lua-language-serverのパスを取得
	local lua_ls_path = vim.fn.trim(vim.fn.system "mise which lua-language-server 2>/dev/null")

	if vim.fn.filereadable(lua_ls_path) == 1 then
		-- LSPサーバーの自動起動設定
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "lua",
			callback = function()
				vim.lsp.start {
					name = "lua_ls",
					cmd = { lua_ls_path },
					root_dir = vim.fs.dirname(vim.fs.find({ "init.lua", ".luarc.json", ".luarc.jsonc" }, { upward = true })[1])
						or vim.fn.getcwd(),
					settings = M.config.settings,
				}
			end,
		})
	else
		vim.notify("lua-language-server not found. Please install it with: mise install", vim.log.levels.WARN)
	end
end

return M
