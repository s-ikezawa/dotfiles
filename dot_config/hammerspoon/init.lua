-- Hammerspoon の設定（~/.config/hammerspoon/init.lua）。
-- 置き場所は mise の [bootstrap.macos.defaults."org.hammerspoon.Hammerspoon"] の MJConfigFile で変えている。

-- ウィンドウを動かすときのアニメーションを切って、すぐに動かす
hs.window.animationDuration = 0

--------------------------------------------------------------------------------
-- 設定ファイルが変わったら読み直す（chezmoi apply で置き換えたときも含む）
--------------------------------------------------------------------------------
ConfigWatcher = hs.pathwatcher.new(hs.configdir, function(paths)
  for _, path in ipairs(paths) do
    if path:sub(-4) == ".lua" then
      hs.reload()
      return
    end
  end
end):start()

--------------------------------------------------------------------------------
-- フォーカスしているウィンドウを、一時的に画面の中央に大きく出す。
-- もう一度押すと、出す前の位置と大きさにそのまま戻す（人に画面を見せて説明するときなど）。
--------------------------------------------------------------------------------
-- 中央に出したときの大きさ。メニューバーと Dock を除いた範囲に対する割合
local centerRatio = { w = 0.6, h = 0.7 }

-- 中央に出す前の位置と大きさ。ウィンドウの ID ごとに覚えておく
local savedFrames = {}

local function toggleCenter()
  local win = hs.window.focusedWindow()
  if not win then
    return
  end

  local id = win:id()
  if savedFrames[id] then
    win:setFrame(savedFrames[id])
    savedFrames[id] = nil
    return
  end

  savedFrames[id] = win:frame()
  local screen = win:screen():frame() -- メニューバーと Dock を除いた範囲
  local w = screen.w * centerRatio.w
  local h = screen.h * centerRatio.h
  win:setFrame({
    x = screen.x + (screen.w - w) / 2,
    y = screen.y + (screen.h - h) / 2,
    w = w,
    h = h,
  })
end

-- Ctrl + Option + Enter
hs.hotkey.bind({ "ctrl", "alt" }, "return", toggleCenter)

hs.alert.show("Hammerspoon の設定を読み込みました")
