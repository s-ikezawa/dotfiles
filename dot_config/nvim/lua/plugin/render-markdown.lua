-- render-markdown: Markdown をバッファの中で整えて見せる（見出しの色分け、表の罫線、コードブロックの背景、
-- チェックボックスや箇条書きのアイコン、リンクのアイコンなど）。Claude が書いた計画や README を読みやすくする。
-- カーソルのある行と挿入モードでは元の記号のまま出るので、そのまま編集できる。
-- パーサーは markdown・markdown_inline（Neovim に同梱）を使い、html（コメントを隠す）と yaml（先頭の frontmatter）は
-- tree-sitter-manager で入れる。アイコンは nvim-web-devicons（neo-tree.lua で入れている）を使う。
-- https://github.com/MeanderingProgrammer/render-markdown.nvim

vim.pack.add({ { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim', version = vim.version.range('*') } }) -- 最新のリリースを追う

require('render-markdown').setup({
  latex = { enabled = false }, -- 数式は使わないので切る（latex のパーサーと utftex などのツールを入れずに済む）
  heading = {
    -- 見出しの「# 」を隠し、アイコンは出さない（空の文字列）。どの階層の見出しも左端から始まる
    -- （既定の overlay は # の上にアイコンを重ねるので、### のように # が多いほど右から始まり、入れ子に見える）。
    -- アイコンを nil にすると # が隠れずに残るので、空の文字列にする。階層は色で見分ける
    position = 'inline',
    icons = { '' },
  },
  sign = { enabled = false }, -- 見出しやコードブロックの印を、行番号の左（サインの列）に出さない
})

vim.keymap.set('n', '<leader>um', '<cmd>RenderMarkdown toggle<cr>', { desc = 'Markdown の整形表示（render-markdown）を切り替える' })
