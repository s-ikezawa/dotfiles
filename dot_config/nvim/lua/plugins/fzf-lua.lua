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

-- アイコンは nvim-web-devicons か mini.icons があれば出るが、どちらも入れていないので出ない。
--
-- no_ignore = true で rg に --no-ignore を付け、.gitignore されたファイルも候補に出す。
-- files と grep(live_grep も grep の設定を使う)の両方に要る。.git の中は files が
-- -g "!.git" で、grep は hidden = false で隠しファイルごと除いているので混ざらない。
-- 一時的に .gitignore を効かせたいときはピッカー内で alt-i を押すと切り替わる。
require("fzf-lua").setup({
  files = { no_ignore = true },
  grep = { no_ignore = true },
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
