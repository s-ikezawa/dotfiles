-- Catppuccin。フレーバーは Mocha(latte / frappe / macchiato / mocha のうち一番暗いもの)。
--
-- vim.pack は 0.12 で入った標準のプラグインマネージャ。git clone した実体は
-- $XDG_DATA_HOME/nvim/site/pack/core/opt/<name> に置かれる。リポジトリ名が nvim なので
-- 何も指定しないとディレクトリ名まで nvim になってしまう。name で catppuccin にする。
--
-- version は semver の範囲で渡すと、その範囲で一番新しいタグを追う。"^2.0" は
-- >=2.0.0 <3.0.0(0.12.5 の vim.version.range で確認。"2.0" と書くと 2.0.x だけになる)。
-- ロックファイル($XDG_CONFIG_HOME/nvim/nvim-pack-lock.json)は chezmoi の管理外に
-- しているため、新しい Mac では revision が固定されない。範囲だけは決めておく。
--
-- プラグインごとにファイルを分けて vim.pack.add を個別に呼んでも起動時間の面で不利にならない。
-- 0.12 で :packadd が Lua の package path キャッシュを壊さなくなったため(:h news)。
vim.pack.add({
  {
    src = "https://github.com/catppuccin/nvim",
    name = "catppuccin",
    version = vim.version.range("^2.0"),
  },
})

-- フレーバーごとにカラースキームが用意されているので、require("catppuccin").setup() を
-- 呼ばずに colorscheme だけで決められる。設定を足したくなったら setup() をこの上に置く。
vim.cmd.colorscheme("catppuccin-mocha")
