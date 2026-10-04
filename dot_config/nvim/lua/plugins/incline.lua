-- incline.nvim。ウィンドウごとの右上に、ファイル名を小さなフロートで出す。
-- ステータスラインを出さない(lua/configs/options.lua の laststatus = 0)代わりに、
-- どのウィンドウに何のファイルを開いているかをここで見せる。
--
-- version を指定していないのは、最新のタグ v0.1.0(2025-11)より後に、カラースキームを
-- 変えたときにハイライトを読み直す修正などが main にだけ入っているため。既定ブランチを追う。
vim.pack.add({
  { src = "https://github.com/b0o/incline.nvim" },
})

-- render はウィンドウごとに呼ばれ、表示する中身を返す。props.buf はそのウィンドウのバッファ。
-- アイコンと色は mini.icons(lua/plugins/mini-icons.lua)から取るので、そちらを先に読む。
-- 変更済みの印 [+] は、組み込みのステータスラインや incline の既定の表示と同じ書き方にする。
--
-- 背景は既定のまま NormalFloat(catppuccin では本文より一段暗い mantle)。カーソル行と
-- 重なったときは既定の hide.cursorline = "smart" でフロートが隠れる。
require("incline").setup({
  render = function(props)
    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
    if name == "" then
      return { "[No Name]" }
    end
    local icon, icon_hl = MiniIcons.get("file", name)
    return {
      { icon, group = icon_hl },
      " ",
      name,
      vim.bo[props.buf].modified and " [+]" or "",
    }
  end,
})
