-- mini.icons。ファイル種別などのアイコンを返す。グリフは Nerd Fonts 3 系を使うので、
-- Ghostty の UDEV Gothic NF で表示できる。
--
-- mini.nvim 全体ではなく単体のリポジトリを入れる。version の "stable" はリリースの
-- ときだけ進むブランチ(README の Installation)。タグ(v0.18.0 など)もあるが、0.x の
-- semver 範囲だとマイナー更新を追えないので、ブランチを追う。
vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.icons", version = "stable" },
})

require("mini.icons").setup()

-- nvim-web-devicons の関数を mini.icons で差し替え、require("nvim-web-devicons") が
-- 通るようにする。mini.icons に直接対応していないプラグイン向け。
-- fzf-lua はこの差し替えを見分けて、MiniIcons を直接使う(fzf-lua の devicons.lua)。
MiniIcons.mock_nvim_web_devicons()
