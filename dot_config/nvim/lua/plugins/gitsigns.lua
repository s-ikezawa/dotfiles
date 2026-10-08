-- gitsigns.nvim。Git の変更行をサインカラムに印で出し、バッファごとの差分の数を
-- b:gitsigns_status_dict(added / changed / removed / head)に置く。
-- その数は incline(lua/plugins/incline.lua)がファイル名の横に出すのに使う。
--
-- version は v3.0.0 が出るまでの間だけ main を追う。出たら vim.version.range("^3.0") に戻す。
-- Neovim 0.11 以上が要る(README の Requirements)。
--
-- v2.1.0 には、外で git commit しても印と差分の数が古いまま残る不具合がある。
-- .git を見張るハンドル(uv_fs_event)の後片付けを GC の finalizer に任せていて、リポジトリの
-- バッファが全部閉じた直後に GC が走ると、ハンドルだけ止まった Repo が弱参照のキャッシュに
-- 残る。同じリポジトリのファイルを開き直すとそれが使い回され、以後 .git の変化に気付かない。
-- 修正は main の c5480c0(参照カウントで片付ける)と 1189caf(fs_event が失敗したら fs_poll に
-- 切り替える)で、v3.0.0 のリリースノートに入っている(リリース PR #1511 は 2026-10-05 時点で未マージ)。
--
-- version を変えただけではディスク上の状態は変わらない。:restart のあと
-- vim.pack.update({ "gitsigns.nvim" }) で切り替える(:h vim.pack)。
vim.pack.add({
  {
    src = "https://github.com/lewis6991/gitsigns.nvim",
    version = "main",
  },
})

require("gitsigns").setup()
