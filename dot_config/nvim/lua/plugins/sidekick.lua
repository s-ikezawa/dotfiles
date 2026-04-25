-- =============================================================================
-- folke/sidekick.nvim
-- =============================================================================
-- 複数の AI CLI (Claude Code / Gemini / Codex / Grok / Copilot CLI / Aider 等) を
-- 統一 UI で扱うための統合プラグイン。
--
-- 採用方針:
--   - サブスクリプション経由の CLI 利用を前提とし、API キーは扱わない
--   - diff 単位の accept/reject は使わず、jj (Jujutsu) のコミット単位でやり直す
--     ワークフローを採用しているため、エディタ内 diff UI 系の機能は使わない
--   - NES (Next Edit Suggestions) は GitHub Copilot LSP/サブスクが必要なので無効化
--
-- 主要 API (キーマップは lua/config/keymaps.lua を参照):
--   require("sidekick.cli").toggle()       直前に開いた CLI をトグル
--   require("sidekick.cli").select()       使用する CLI をピッカーから選択
--   require("sidekick.cli").send()         選択範囲/バッファを CLI に送信
--   require("sidekick.cli").prompt()       Prompt Library を開く
--   require("sidekick.cli").focus()        既に開いている CLI にフォーカス
--
-- 詳細: :help sidekick / https://github.com/folke/sidekick.nvim
-- =============================================================================

require("sidekick").setup({
  -- Next Edit Suggestions: Copilot LSP に依存するため無効化
  -- (利用する場合は Copilot サブスクと copilot-language-server が必要)
  nes = {
    enabled = false,
  },

  -- CLI 統合の設定
  cli = {
    -- ターミナルマルチプレクサ統合 (tmux/zellij)
    -- tmux セッションに CLI を逃がすことで Neovim を終了しても会話状態を保持する。
    -- create = "terminal" のままなので表示自体は引き続き Neovim 内ターミナル。
    mux = {
      enabled = true,
      backend = "tmux",
    },
    -- ウィンドウ表示位置・サイズなどはデフォルト (右側のフロート/分割) を使う
  },
})
