--=========================================================================
-- Options
--=========================================================================
if not vim.g.vscode then
  -- 行番号を相対行番号で表示
  vim.opt.number = true
  vim.opt.relativenumber = true
end

-- クリップボード連携
vim.opt.clipboard = "unnamedplus"

