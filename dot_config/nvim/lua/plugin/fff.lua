-- fff: ファイル名と本文のあいまい検索。打ち間違いに強く、よく開くファイルや git で変更したファイルを上に出す。
-- 裏でファイルの変更を見張っているので、Claude Code が作ったファイルもすぐ候補に出る。
-- 本体は Rust 製で、入れたときと更新したときにビルド済みのものを自動で落とす。
-- 一覧では <C-n>・<C-p> で選び、<CR> で開く。<Tab> で複数選んで <C-q> で quickfix へ送る。<Esc> で閉じる。
-- https://github.com/dmtrKovalenko/fff

-- 入れたとき・更新したときに本体を落とす（vim.pack.add の中で起きるので、add より先に登録する）
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('config_fff_build', { clear = true }),
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'fff' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then vim.cmd.packadd('fff') end
      require('fff.download').download_or_build_binary()
    end
  end,
})

vim.pack.add({ { src = 'https://github.com/dmtrKovalenko/fff', version = vim.version.range('*') } }) -- 最新のリリースを追う

-- 設定。fff は初めて使うときに自分で初期化するので、setup() ではなくこの変数で渡す
vim.g.fff = {
  git = {
    status_text_color = true, -- ファイル名を git の状態（変更・追加など）で色分けする
  },
}

local function fff(fn, opts)
  return function() require('fff')[fn](opts) end
end

vim.keymap.set('n', '<leader><space>', fff('find_files'), { desc = 'ファイルを探す' })
vim.keymap.set('n', '<leader>ff', fff('find_files'), { desc = 'ファイルを探す' })
vim.keymap.set('n', '<leader>fg', fff('live_grep'), { desc = '本文を grep する（<S-Tab> で正規表現・あいまいに切り替え）' })
vim.keymap.set('n', '<leader>fz', fff('live_grep', { grep = { modes = { 'fuzzy', 'plain' } } }), { desc = '本文をあいまいに grep する' })
vim.keymap.set({ 'n', 'x' }, '<leader>fw', fff('live_grep_under_cursor'), { desc = 'カーソル位置の語（選択範囲）で grep する' })
