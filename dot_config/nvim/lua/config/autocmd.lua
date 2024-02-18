-- Format on Save
local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
vim.api.nvim_create_autocmd("BufWritePost", {
	group = lsp_fmt_group,
	callback = function()
		local efm = vim.lsp.get_active_clients({ name = "efm" })
		if vim.tbl_isempty(efm) then
			return
		end

		vim.lsp.buf.format({ name = "efm" })
	end,
})

-- コメント行で改行すると次の行が自動的にコメントにならないようにする
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("turn_off_auto_commenting", {}),
  pattern = "*",
  command = [[setlocal fo-=cro]]
})
