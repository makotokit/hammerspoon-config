-- WindowHalfsAndThirds を使ったウィンドウ配置ショートカット
-- 事前に Spoon を ~/.hammerspoon/Spoons/ に配置してください:
-- https://www.hammerspoon.org/Spoons/WindowHalfsAndThirds.html
-- 例:
-- ~/.hammerspoon/Spoons/WindowHalfsAndThirds.spoon/init.lua

hs.loadSpoon("WindowHalfsAndThirds")

spoon.WindowHalfsAndThirds:bindHotkeys({
    left_half = { { "ctrl", "cmd" }, "Left" },
    right_half = { { "ctrl", "cmd" }, "Right" },
    third_left = { { "ctrl", "cmd", "alt" }, "Left" },
    third_right = { { "ctrl", "cmd", "alt" }, "Right" },
    max = { { "ctrl", "cmd" }, "home" },
    -- center = { { "ctrl", "cmd" }, "end" },
    -- larger = { { "ctrl", "cmd" }, "Up" },
    --smaller = { { "ctrl", "cmd" }, "Down" },
})

local function moveFocusedWindowToUnit(unit)
    local win = hs.window.focusedWindow()
    if not win then
        return
    end
    win:moveToUnit(unit)
end

-- 2/3 配置はカスタムで確実に動かす
hs.hotkey.bind({ "ctrl", "cmd" }, "Down", function()
    moveFocusedWindowToUnit({ x = 0, y = 0, w = 2 / 3, h = 1 })
end)

hs.hotkey.bind({ "ctrl", "cmd" }, "Up", function()
    moveFocusedWindowToUnit({ x = 1 / 3, y = 0, w = 2 / 3, h = 1 })
end)
