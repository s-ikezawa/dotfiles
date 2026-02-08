-- Go のインデント設定（gofmt の慣習に従いタブを使用）
vim.bo.expandtab = false
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4

-- gotests: テストコード自動生成
-- https://github.com/cweill/gotests
vim.keymap.set("n", "<leader>ct", function()
  local func_name = vim.fn.expand("<cword>")
  local file = vim.fn.expand("%:p")
  local cmd = string.format("gotests -w -only %q %q", func_name, file)
  vim.fn.system(cmd)
  vim.notify("テスト生成: " .. func_name, vim.log.levels.INFO)
  -- 対応する _test.go を開く
  local test_file = vim.fn.expand("%:p:r") .. "_test.go"
  if vim.fn.filereadable(test_file) == 1 then
    vim.cmd.edit(test_file)
  end
end, { buffer = 0, desc = "Go: カーソル下の関数のテストを生成" })

vim.keymap.set("n", "<leader>cT", function()
  local file = vim.fn.expand("%:p")
  local cmd = string.format("gotests -w -all %q", file)
  vim.fn.system(cmd)
  vim.notify("テスト生成: 全関数", vim.log.levels.INFO)
  local test_file = vim.fn.expand("%:p:r") .. "_test.go"
  if vim.fn.filereadable(test_file) == 1 then
    vim.cmd.edit(test_file)
  end
end, { buffer = 0, desc = "Go: 全関数のテストを生成" })

-- ソース/テストファイル切り替え (Go Alternate)
vim.keymap.set("n", "<leader>tA", function()
  local file = vim.fn.expand("%:p")
  local alt

  if file:match("_test%.go$") then
    alt = file:gsub("_test%.go$", ".go")
  elseif file:match("%.go$") then
    alt = file:gsub("%.go$", "_test.go")
  else
    vim.notify("Go ファイルではありません", vim.log.levels.WARN)
    return
  end

  if vim.fn.filereadable(alt) == 0 then
    vim.notify("ファイルが見つかりません: " .. alt, vim.log.levels.WARN)
    return
  end

  -- 既にウィンドウに表示されていればフォーカス移動
  for _, win in ipairs(vim.fn.getwininfo()) do
    if vim.api.nvim_buf_get_name(win.bufnr) == alt then
      vim.api.nvim_set_current_win(win.winid)
      return
    end
  end

  -- ウィンドウ幅160以上なら垂直分割、未満なら水平分割
  if vim.api.nvim_win_get_width(0) >= 160 then
    vim.cmd.vsplit(alt)
  else
    vim.cmd.split(alt)
  end
end, { buffer = 0, desc = "Go: ソース/テストファイルをスマート分割で表示" })

-- gomodifytags: 構造体タグ操作
-- https://github.com/fatih/gomodifytags
vim.keymap.set("n", "<leader>ca", function()
  vim.ui.input({ prompt = "追加するタグ (例: json,yaml): " }, function(tags)
    if not tags or tags == "" then
      return
    end
    local file = vim.fn.expand("%:p")
    local line = vim.fn.line(".")
    local cmd = string.format("gomodifytags -file %q -line %d -add-tags %s -w -quiet", file, line, tags)
    vim.fn.system(cmd)
    vim.cmd.edit()
    vim.notify("タグ追加: " .. tags, vim.log.levels.INFO)
  end)
end, { buffer = 0, desc = "Go: 構造体フィールドにタグを追加" })

vim.keymap.set("n", "<leader>cr", function()
  vim.ui.input({ prompt = "削除するタグ (例: json,yaml): " }, function(tags)
    if not tags or tags == "" then
      return
    end
    local file = vim.fn.expand("%:p")
    local line = vim.fn.line(".")
    local cmd = string.format("gomodifytags -file %q -line %d -remove-tags %s -w -quiet", file, line, tags)
    vim.fn.system(cmd)
    vim.cmd.edit()
    vim.notify("タグ削除: " .. tags, vim.log.levels.INFO)
  end)
end, { buffer = 0, desc = "Go: 構造体フィールドからタグを削除" })

vim.keymap.set("v", "<leader>ca", function()
  vim.ui.input({ prompt = "追加するタグ (例: json,yaml): " }, function(tags)
    if not tags or tags == "" then
      return
    end
    local file = vim.fn.expand("%:p")
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    local cmd =
      string.format("gomodifytags -file %q -line %d,%d -add-tags %s -w -quiet", file, start_line, end_line, tags)
    vim.fn.system(cmd)
    vim.cmd.edit()
    vim.notify("タグ追加: " .. tags, vim.log.levels.INFO)
  end)
end, { buffer = 0, desc = "Go: 選択範囲の構造体フィールドにタグを追加" })

vim.keymap.set("v", "<leader>cr", function()
  vim.ui.input({ prompt = "削除するタグ (例: json,yaml): " }, function(tags)
    if not tags or tags == "" then
      return
    end
    local file = vim.fn.expand("%:p")
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    local cmd =
      string.format("gomodifytags -file %q -line %d,%d -remove-tags %s -w -quiet", file, start_line, end_line, tags)
    vim.fn.system(cmd)
    vim.cmd.edit()
    vim.notify("タグ削除: " .. tags, vim.log.levels.INFO)
  end)
end, { buffer = 0, desc = "Go: 選択範囲の構造体フィールドからタグを削除" })
