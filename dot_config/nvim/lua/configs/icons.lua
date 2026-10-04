-- 複数のプラグインや設定で共通して使うアイコン。
--
-- 設定ではなくアイコンの表を返すだけのモジュールなので、init.lua からは読まない。
-- 使う側が require("configs.icons") で取る。
-- ファイルの種類ごとのアイコンは mini.icons(lua/plugins/mini-icons.lua)に任せ、ここには
-- mini.icons に無い記号(診断・Git の差分など)を置く。
--
-- 文字は Nerd Fonts 3 のコードポイントで書き、グリフ名を横に添える。どれも Ghostty で
-- 使っている UDEV Gothic NF に入っていることを、フォントの cmap で確認した。
local M = {}

-- 診断の重大度ごと。キーは vim.diagnostic.severity の名前に合わせる。
M.diagnostics = {
  ERROR = "\u{f00d}", -- fa-xmark
  WARN = "\u{f071}", -- fa-warning
  INFO = "\u{f05a}", -- fa-info_circle
  -- incline の README の例は U+F834 を使っているが、Nerd Fonts 3 で消えたコードポイントで
  -- UDEV Gothic NF に入っていない。同じ Octicons の電球にする。
  HINT = "\u{f400}", -- oct-light_bulb
}

-- Git の差分の種類ごと。キーは gitsigns の b:gitsigns_status_dict に合わせる。
M.git = {
  added = "\u{f457}", -- oct-diff_added
  changed = "\u{f459}", -- oct-diff_modified
  removed = "\u{f458}", -- oct-diff_removed
}

return M
