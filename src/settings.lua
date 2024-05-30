local settings = {}

local game = require('game')
local buttons = {}
local buttonWidth = 300
local buttonHeight = 100

local buttonState = {
    normal = love.graphics.newImage("assets/Button/normal.png"),
    hover = love.graphics.newImage("assets/Button/hover.png"),
    pressed = love.graphics.newImage("assets/Button/pressed.png")
}

local settingsFont
local settings_background

local soundEnabled = true

local keybinds = {
    shoot1 = "t",
    shoot2 = "m"
}

local waitingForKey = nil

function settings.load()
    settingsFont = love.graphics.newFont(30)
    settings_background = love.graphics.newImage("assets/settings_background.jpg")

    buttons = {
        {
            x = love.graphics.getWidth() / 2 - buttonWidth / 2,
            y = love.graphics.getHeight() / 3,
            width = buttonWidth,
            height = buttonHeight,
            state = "normal",
            text = "Sound: On",
            onClick = function()
                soundEnabled = not soundEnabled
                buttons[1].text = soundEnabled and "Sound: On" or "Sound: Off"
            end
        },
        {
            x = love.graphics.getWidth() / 2 - buttonWidth / 2,
            y = love.graphics.getHeight() / 3 + 120,
            width = buttonWidth,
            height = buttonHeight,
            state = "normal",
            text = "Shoot 1: " .. keybinds.shoot1,
            onClick = function()
                waitingForKey = "shoot1"
            end
        },
        {
            x = love.graphics.getWidth() / 2 - buttonWidth / 2,
            y = love.graphics.getHeight() / 3 + 240,
            width = buttonWidth,
            height = buttonHeight,
            state = "normal",
            text = "Shoot 2: " .. keybinds.shoot2,
            onClick = function()
                waitingForKey = "shoot2"
            end
        },
        {
            x = love.graphics.getWidth() - buttonWidth - 20,
            y = love.graphics.getHeight() - buttonHeight - 30,
            width = buttonWidth,
            height = buttonHeight,
            state = "normal",
            text = "Back",
            onClick = function()
                gameState = "menu"
            end
        }
    }
end

function settings.update(dt)
    local mx, my = love.mouse.getPosition()
    for _, button in ipairs(buttons) do
        if mx > button.x and mx < button.x + button.width and my > button.y and my < button.y + button.height then
            if love.mouse.isDown(1) then
                button.state = "pressed"
            else
                button.state = "hover"
            end
        else
            button.state = "normal"
        end
    end

    if not soundEnabled then
        love.audio.setVolume(0)
    else
        love.audio.setVolume(50)
    end
end

function settings.draw()
    love.graphics.draw(settings_background, 0, 0, 0, 1, 1)

    love.graphics.setFont(settingsFont)
    for _, button in ipairs(buttons) do
        love.graphics.draw(buttonState[button.state], button.x, button.y, 0, button.width / buttonState[button.state]:getWidth(), button.height / buttonState[button.state]:getHeight())
        love.graphics.printf(button.text, button.x, button.y + (button.height / 2 - 10), button.width, "center")
    end

    if waitingForKey then
        love.graphics.printf("Press a key for " .. waitingForKey, 0, love.graphics.getHeight() / 2 - 50, love.graphics.getWidth(), "center")
    end
end

function settings.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        for _, btn in ipairs(buttons) do
            if x > btn.x and x < btn.x + btn.width and y > btn.y and y < btn.y + btn.height then
                btn.onClick()
            end
        end
    end
end

function settings.keypressed(key)
    if waitingForKey then
        keybinds[waitingForKey] = key
        for _, btn in ipairs(buttons) do
            if btn.text:find(waitingForKey) then
                btn.text = waitingForKey:sub(1, 1):upper() .. waitingForKey:sub(2) .. ": " .. key
            end
        end
        waitingForKey = nil
    end
end

return settings
