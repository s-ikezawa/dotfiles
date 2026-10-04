-- neo-tree.nvim。ファイルツリー。
-- サイドバーに常駐させず、見たいときだけ画面中央のフロートで開く(window.position = "float")。
-- ファイルを開くとフロートは閉じる。
--
-- version は README の vim.pack の例のとおり "3"(>=3.0.0 <4.0.0)。3.x はタグが定期的に打たれている。
-- plenary.nvim(ファイルの走査などに使う)と nui.nvim(画面の部品)が要る。nui.nvim は searchbox
-- (lua/plugins/searchbox.lua)と共有する。plenary はタグが 2024 年の v0.1.4 で止まっているので
-- 既定ブランチを追う。
-- アイコンは nvim-web-devicons を使う作りで、mini.icons が肩代わりしている(lua/plugins/mini-icons.lua)。
vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  {
    src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
    version = vim.version.range("3"),
  },
})

-- 診断の記号は vim.diagnostic.config の signs.text(lua/configs/diagnostic.lua)をそのまま使う。
-- Git の状態の表示と診断の表示は既定で有効。
require("neo-tree").setup({
  -- 入力や確認のフロートの枠。"" で winborder("rounded")に従い、: や検索のフロートと揃える。
  popup_border_style = "",
  window = {
    position = "float",
  },
  filesystem = {
    -- 子が 1 つしかないフォルダを api/src/modules/user のように 1 行にまとめる(VSCode の
    -- Compact Folders)。フォルダが深いモノレポでも一覧で見渡せる。まとめられるかを開く前に
    -- 知るため、フォルダの中を先に走査する(scan_mode = "deep")。
    group_empty_dirs = true,
    scan_mode = "deep",
  },
})

-- 開いているファイルの位置までツリーを展開して開く。開いていれば閉じる。
-- ツリーの中の主なキー(既定):
--   <CR> 開く / a 作成 / r 名前の変更 / d 削除 / c コピー / m 移動 / ? キーの一覧
--   P プレビューモードの切り替え(カーソルを動かすと横のフロートに中身が出る)
--   l プレビューへ移る(そのまま編集できる) / <C-f> <C-b> プレビューのスクロール
vim.keymap.set("n", "<leader>e", "<Cmd>Neotree toggle reveal<CR>", { desc = "neo-tree: ファイルツリー" })
