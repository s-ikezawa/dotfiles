vim.pack.add({
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/rcarriga/nvim-dap-ui",
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/theHamsta/nvim-dap-virtual-text",
  -- provider
  "https://github.com/leoluz/nvim-dap-go",
})

-- nvim-dap-go: delve アダプターを自動設定
require("dap-go").setup()

-- nvim-dap-ui
local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

-- nvim-dap-virtual-text: デバッグ中に変数の値をインラインで表示
require("nvim-dap-virtual-text").setup({
  commented = true, -- コメント形式で表示（例: // x = 42）
})

-- ブレークポイントのアイコン設定
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DiagnosticInfo" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "DapStoppedLine" })
vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticError" })

-- デバッグセッション開始/終了時にUIを自動で開閉
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- ブレークポイント
vim.keymap.set("n", "<leader>db", function()
  dap.toggle_breakpoint()
end, { desc = "ブレークポイントを切替" })

vim.keymap.set("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "条件付きブレークポイントを設定" })

-- 実行制御
vim.keymap.set("n", "<leader>dc", function()
  dap.continue()
end, { desc = "デバッグ開始/続行" })

vim.keymap.set("n", "<leader>di", function()
  dap.step_into()
end, { desc = "ステップイン" })

vim.keymap.set("n", "<leader>do", function()
  dap.step_over()
end, { desc = "ステップオーバー" })

vim.keymap.set("n", "<leader>dO", function()
  dap.step_out()
end, { desc = "ステップアウト" })

vim.keymap.set("n", "<leader>dl", function()
  dap.run_to_cursor()
end, { desc = "カーソル位置まで実行" })

vim.keymap.set("n", "<leader>dr", function()
  dap.restart()
end, { desc = "デバッグを再開" })

vim.keymap.set("n", "<leader>dt", function()
  dap.terminate()
end, { desc = "デバッグを終了" })

-- UI
vim.keymap.set("n", "<leader>du", function()
  dapui.toggle()
end, { desc = "デバッグUIを表示切替" })

vim.keymap.set({ "n", "v" }, "<leader>de", function()
  dapui.eval()
end, { desc = "式を評価" })

-- Go テストのデバッグ
vim.keymap.set("n", "<leader>dg", function()
  require("dap-go").debug_test()
end, { desc = "最も近いGoテストをデバッグ" })

vim.keymap.set("n", "<leader>dG", function()
  require("dap-go").debug_last_test()
end, { desc = "最後のGoテストを再デバッグ" })
