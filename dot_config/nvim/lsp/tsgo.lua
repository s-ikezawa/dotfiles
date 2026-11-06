-- TypeScript・JavaScript の言語サーバーの設定。
-- TypeScript 7（Go 製。mise で npm:typescript として導入）に組み込まれた言語サーバーを使う。

---@type vim.lsp.Config
return {
  cmd = { 'tsc', '--lsp', '--stdio' },                -- 起動するコマンド
  filetypes = {                                       -- このファイルタイプのバッファで動かす
    'javascript', 'javascriptreact', 'typescript', 'typescriptreact',
  },
  root_markers = {                                    -- 上の階層へ探して、最初に見つかった場所をプロジェクトのルートにする
    { 'tsconfig.json', 'jsconfig.json' },             -- TypeScript・JavaScript の設定ファイル
    { 'package-lock.json', 'pnpm-lock.yaml', 'yarn.lock', 'bun.lock' }, -- パッケージのロックファイル（モノレポのルート）
    '.git',
  },
}
