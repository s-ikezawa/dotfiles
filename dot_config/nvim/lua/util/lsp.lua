local M = {}

M.on_attach = function(client, bufnr)
	local keymap_opts = { noremap = true, silent = true, buffer = bufnr }

	vim.keymap.set("n", "<leader>fd", ":Lspsaga finder<CR>", keymap_opts)
	vim.keymap.set("n", "<leader>gd", ":Lspsaga peek_definition<CR>", keymap_opts)
	vim.keymap.set("n", "<leader>gD", ":Lspsaga goto_definition<CR>", keymap_opts)
	vim.keymap.set("n", "<leader>ca", ":Lspsaga code_action<CR>", keymap_opts)
	vim.keymap.set("n", "<leader>rn", ":Lspsaga rename<CR>", keymap_opts)
	vim.keymap.set("n", "<leader>D", ":Lspsaga show_line_diagnostics<CR>", keymap_opts)
	vim.keymap.set("n", "<leader>d", ":Lspsaga show_cursor_diagnostics<CR>", keymap_opts)
	vim.keymap.set("n", "<leader>pd", ":Lspsaga diagnostic_jump_prev<CR>", keymap_opts)
	vim.keymap.set("n", "<leader>nd", ":Lspsaga diagnostic_jump_next<CR>", keymap_opts)
	vim.keymap.set("n", "K", ":Lspsaga hover_doc<CR>", keymap_opts)
end

return M
