-- fzf-lua。ファジーファインダー。
--
-- 絞り込みは外部の fzf バイナリに投げる(mise で入れている)。ファイル列挙と grep には
-- fd / rg があればそちらを使うので、ripgrep が入っているこの環境ではそのまま速い。
--
-- version を指定していないのは、fzf-lua がリリースタグを打っていないため(タグは 0.7 と
-- pre_windows の 2 つだけで、更新が続いている main には付いていない)。既定ブランチを追う。
-- ロックファイルを chezmoi の管理外にしているので、新しい Mac ではその時点の main が入る。
-- 固定したくなったら version にリビジョン(ロックファイルの rev)を書く。
vim.pack.add({
  { src = "https://github.com/ibhagwan/fzf-lua" },
})

-- アイコンは mini.icons(lua/plugins/mini-icons.lua)から取るので、そちらを先に読む。
--
-- no_ignore = true で rg に --no-ignore を付け、.gitignore されたファイルも候補に出す。
-- files と grep(live_grep も grep の設定を使う)の両方に要る。.git の中は files が
-- -g "!.git" で、grep は hidden = false で隠しファイルごと除いているので混ざらない。
-- 一時的に .gitignore を効かせたいときはピッカー内で alt-i を押すと切り替わる。
--
-- node_modules は .gitignore と関係なく常に除く。rg の -g はファイルを無視する設定とは別物
-- なので、--no-ignore を付けても効き、どの階層の node_modules も除かれる(rg 15.2.0 で確認)。
-- 既定のオプションに足す口が無いので、README に載っている既定値に -g / --exclude を足して
-- 丸ごと書く。fzf-lua を更新して既定値が変わったら合わせる。
-- fd_opts は今は使われない(fd を入れていない)。fd を入れると files はそちらを使うので、
-- そのときも node_modules が出ないように書いておく。
-- grep の rg_opts は末尾の -e の直後に検索語が来るので、-g は -e より前に置く。
require("fzf-lua").setup({
  files = {
    no_ignore = true,
    rg_opts = [[--color=never --files -g "!.git" -g "!.jj" -g "!node_modules"]],
    fd_opts = [[--color=never --type f --type l --exclude .git --exclude .jj --exclude node_modules]],
  },
  grep = {
    no_ignore = true,
    rg_opts = [[--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g "!node_modules" -e]],
  },
})

-- キーマップ。リーダーは lua/configs/keymaps.lua でスペースにしている。
-- <Cmd> を使うとコマンドモードに降りずに実行されるので、レジスタや検索の状態が汚れない。
local map = function(lhs, picker, desc)
  vim.keymap.set("n", lhs, "<Cmd>FzfLua " .. picker .. "<CR>", { desc = "fzf-lua: " .. desc })
end

map("<leader>gs", "git_status", "git の変更ファイル")
map("<leader>ff", "files", "ファイル検索")
map("<leader>fg", "live_grep", "全文検索")
map("<leader>fb", "buffers", "バッファ一覧")
map("<leader>fr", "resume", "直前のピッカーを再開")
