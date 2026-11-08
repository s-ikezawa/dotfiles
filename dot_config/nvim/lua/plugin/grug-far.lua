-- grug-far: プロジェクト全体の検索と置換を 1 つのバッファで行う。検索には rg か ast-grep（構文の形で探す）を使う。
-- 検索語・置換後・ファイルの絞り込み・rg のフラグを書くと、打つそばから結果と置換後の差分が出る。
-- 結果の行をそのまま書き換えて元のファイルに戻すこともできる（rg のときだけ）。
-- バッファの中のキーは <localleader>（\）で始まる。\r で置換、\e で rg と ast-grep を切り替え、g? でキーの一覧。
-- https://github.com/MagicDuck/grug-far.nvim

vim.pack.add({ { src = 'https://github.com/MagicDuck/grug-far.nvim', version = vim.version.range('*') } }) -- 最新のリリースを追う

require('grug-far').setup({})

-- ノーマルモードでは空で開き、ビジュアルモードでは選んだ文字列を検索語に入れて開く
local function grug_far(engine)
  return function()
    local grug = require('grug-far')
    if vim.fn.mode():find('^[vV\22]') then
      grug.with_visual_selection({ engine = engine })
    else
      grug.open({ engine = engine })
    end
  end
end

vim.keymap.set({ 'n', 'x' }, '<leader>sr', grug_far('ripgrep'), { desc = 'プロジェクト全体を検索・置換する（rg）' })
vim.keymap.set({ 'n', 'x' }, '<leader>sa', grug_far('astgrep'), { desc = 'プロジェクト全体を構文の形で検索・置換する（ast-grep）' })
