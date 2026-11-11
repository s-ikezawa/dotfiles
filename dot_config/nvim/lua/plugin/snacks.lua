-- snacks: いろいろな機能の詰め合わせだが、画像の表示（image）だけを使う。
-- Markdown の中の画像（![...](...)）を、その場（画像を書いた行の下）に表示する。画像のファイルを開いたときも表示する。
-- PNG 以外（SVG・JPEG など）は ImageMagick（magick）で PNG に変えて出す。SVG は rsvg-convert で変換させている
-- （~/.config/ImageMagick/delegates.xml）。ImageMagick と librsvg は mise の [bootstrap.packages] で Homebrew から入れる。
-- 画像は kitty の画像表示の仕組みで描くので、Ghostty のように対応したターミナルでしか出ない。
-- https://github.com/folke/snacks.nvim/blob/main/docs/image.md

-- herdr の中では TERM_PROGRAM が herdr になり、snacks は外側の Ghostty に気付けない。
-- herdr は画像を外側のターミナルに中継する（herdr の kitty_graphics。既定で有効）ので、Ghostty だと教える
if vim.env.TERM_PROGRAM == 'herdr' then vim.env.SNACKS_GHOSTTY = 'true' end

vim.pack.add({ { src = 'https://github.com/folke/snacks.nvim', version = vim.version.range('*') } }) -- 最新のリリースを追う

require('snacks').setup({
  image = { enabled = true },
})
