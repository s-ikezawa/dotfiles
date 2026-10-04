-- 診断(vim.diagnostic)の表示。LSP などが出す診断すべてに効く。
--
-- サインカラムの印を、既定の E / W / I / H から lua/configs/icons.lua の記号に変える。
-- incline(lua/plugins/incline.lua)が数と一緒に出す記号と同じものになる。
-- signs.text はサインカラムのほか、vim.diagnostic.status() の文字列にも使われる(:h vim.diagnostic.Opts.Signs)。
-- 色は既定の DiagnosticSign* のまま。
local icons = require("configs.icons")
local severity = vim.diagnostic.severity

vim.diagnostic.config({
  signs = {
    text = {
      [severity.ERROR] = icons.diagnostics.ERROR,
      [severity.WARN] = icons.diagnostics.WARN,
      [severity.INFO] = icons.diagnostics.INFO,
      [severity.HINT] = icons.diagnostics.HINT,
    },
  },
})
