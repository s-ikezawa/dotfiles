-- =============================================================================
-- MeanderingProgrammer/render-markdown.nvim
-- =============================================================================
-- Markdown ファイルをバッファ内で「読み物」として整形表示する装飾プラグイン。
-- - 見出しレベルに応じたアイコン / 背景色
-- - テーブルを罫線でリッチ表示
-- - checkbox を視覚化 ([ ] -> ☐, [x] -> ☑ 等)
-- - コードブロックの言語ラベル / 枠線
-- - リンク・カラーコード・引用ブロックの装飾
--
-- 役割分担:
--   - 装飾 (テキストレベルの見た目変換)        → render-markdown.nvim ★
--   - 画像 / Mermaid / LaTeX の実画像レンダ    → snacks.image
--
-- 詳細: :help render-markdown / https://github.com/MeanderingProgrammer/render-markdown.nvim
-- =============================================================================

require("render-markdown").setup({
  -- 既存設定を尊重しつつ、本プラグインが動作する filetypes を明示。
  -- デフォルトは { "markdown" } のみだが、Codecompanion/Avante のチャット用
  -- markdown バッファ等を将来追加するならここに足す。
  file_types = { "markdown" },

  -- ----- snacks.image との棲み分け -------------------------------------------
  -- render-markdown はデフォルトで code.conceal_delimiters = true となっており、
  -- ```lang や ``` を conceal して borders に置き換える。これは綺麗だが、
  -- snacks.image が同じ位置に画像プレースホルダの extmark を打つので衝突する
  -- (画像が表示されない / カーソルを動かすまで見えない、といった症状が出る)。
  --
  -- 解決策: snacks.image が処理する言語 (mermaid 等) を render-markdown 側で
  -- 完全に無視させる。これらのブロックでは ``` は素のまま表示されるが、
  -- snacks.image が画像をインライン表示してくれるので実害なし。
  code = {
    disable = { "mermaid" },
  },
})
