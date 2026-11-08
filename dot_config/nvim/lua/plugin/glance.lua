-- glance: 定義・参照・実装・型定義を、その場のフローティングウィンドウで覗く（VS Code の Peek）。
-- 左にコードのプレビュー、右に見つかった場所の一覧が出る。ジャンプせずに読め、プレビューの中で編集もできる。
-- 標準の gd・grr・gri・grt を置き換える。結果が 1 件ならこれまでどおり直接移り、2 件以上のときだけ glance を出す。
-- 一覧では j・k で選び、<CR>・o で移る。v・s で縦・横に分けて開き、<Tab> で次の場所へ、q・<Esc> で閉じる。
-- <C-q> で一覧を trouble に送る。<leader>l でプレビューと一覧を行き来する。
-- https://github.com/DNLHC/glance.nvim

vim.pack.add({ 'https://github.com/DNLHC/glance.nvim' }) -- リリースのタグがないので既定のブランチを追う

require('glance').setup({
  hooks = {
    -- 結果が 1 件ならウィンドウを出さずにその場所へ移る
    before_open = function(results, open, jump)
      if #results == 1 then
        jump(results[1])
      else
        open(results)
      end
    end,
  },
  use_trouble_qf = true, -- <C-q> で一覧を quickfix ではなく trouble に送る
  border = {
    -- 上下に横線を引いて、元のコードとの境目をわかりやすくする（glance は左右の縦線には対応していない）。
    -- 線の文字は、ほかのフローティングウィンドウの枠（winborder = 'rounded'）と同じ罫線にする
    enable = true,
    top_char = '─',
    bottom_char = '─',
  },
})

-- 言語サーバーがつながったバッファだけで置き換える（ほかのバッファでは gd などは Neovim 標準のまま）
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('config_glance', { clear = true }),
  callback = function(args)
    local function map(lhs, method, desc)
      vim.keymap.set('n', lhs, '<cmd>Glance ' .. method .. '<cr>', { buffer = args.buf, desc = desc })
    end
    map('gd', 'definitions', '定義へ移る（複数なら glance で覗く）')
    map('grr', 'references', '参照を glance で覗く')
    map('gri', 'implementations', '実装へ移る（複数なら glance で覗く）')
    map('grt', 'type_definitions', '型定義へ移る（複数なら glance で覗く）')
  end,
})
