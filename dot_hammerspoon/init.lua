-- リロード用のキーバインドを設定
hs.hotkey.bind({"ctrl", "shift"}, "r", function()
  hs.reload()
end)

-- init.lua を保存したら自動でリロード（手動キーに頼らなくて済む）
local configWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", function(files)
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      hs.reload()
      return
    end
  end
end)
configWatcher:start()

-- 読み込み完了を可視化（リロードが効いているかの確認用）
hs.alert.show("Hammerspoon 設定を読み込みました")

-- 4Kディスプレイ専用レイアウト（中央=Ghostty / 右上=Firefox / 右下=Chrome）
-- ※ SCREEN_NAME は自宅4Kモニタの名前に書き換える（取得方法は下のコメント参照）
local SCREEN_NAME = "DELL U4320Q"

-- 接続中の画面から対象の4Kを探す。見つからなければ nil
local function find4KScreen()
  return hs.screen.find(SCREEN_NAME)
end

local function applyMyLayout()
  local screen = find4KScreen()
  if not screen then
    hs.alert.show("4Kディスプレイ（" .. SCREEN_NAME .. "）が見つかりません")
    return
  end

  -- 3枚を起動or前面化（無ければ起動）
  for _, app in ipairs({"Ghostty", "Firefox", "Google Chrome"}) do
    hs.application.launchOrFocus(app)
  end

  -- 起動直後でウィンドウ生成が間に合わないことがあるので少し待ってから配置
  hs.timer.doAfter(0.4, function()
    -- 第4要素は「画面比率(0〜1)」の枠。解像度・スケーリングに依存せず効く
    hs.layout.apply({
      {"Ghostty",       nil, screen, hs.geometry.rect(0,     0,      2/3, 1.0), nil, nil},
      {"Google Chrome", nil, screen, hs.geometry.rect(2/3,   0,      1/3, 2/3), nil, nil},
      {"Firefox",       nil, screen, hs.geometry.rect(2/3,   2/3,    1/3, 1/3), nil, nil},
    })
    -- ※「その他アプリ」は何もしない＝自然にGhosttyの上へ重なる
  end)
end

hs.hotkey.bind({"ctrl", "alt"}, "l", applyMyLayout)
