local menu = {}
local game = require("game")
local settings = require("settings")

local buttons = {}
local buttonWidth = 300
local buttonHeight = 100

local buttonState = {
    normal = love.graphics.newImage("assets/Button/normal.png"),
    hover = love.graphics.newImage("assets/Button/hover.png"),
    pressed = love.graphics.newImage("assets/Button/pressed.png")
}

local menuFont
local loading_sprite = love.graphics.newImage("assets/loading.png")

function menu.load()
    menuFont = love.graphics.newFont(30)
    buttons = {
        {
            x = love.graphics.getWidth() / 2 - buttonWidth / 2,
            y = love.graphics.getHeight() / 2 - 10,
            width = buttonWidth,
            height = buttonHeight,
            state = "normal",
            text = "1 vs 1 (local)",
            onClick = function()
                gameState = "game"
                game.load()
            end
        },
        {
            x = love.graphics.getWidth() / 2 - buttonWidth / 2,
            y = love.graphics.getHeight() / 2 + 110,
            width = buttonWidth,
            height = buttonHeight,
            state = "normal",
            text = "Settings",
            onClick = function()
                gameState = "settings"
                settings.load()
            end
        },
        {
            x = love.graphics.getWidth() / 2 - buttonWidth / 2,
            y = love.graphics.getHeight() / 2 + 230,
            width = buttonWidth,
            height = buttonHeight,
            state = "normal",
            text = "Quit",
            onClick = function()
                love.event.quit()
            end
        }
    }

    menu.mousepressed(x, y, button, istouch, presses)
end

function menu.update(dt)
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
end

function menu.draw()
    love.graphics.setFont(menuFont)
    love.graphics.draw(loading_sprite, 0, 0, 0, 0.76, 1)
    for _, button in ipairs(buttons) do
        love.graphics.draw(buttonState[button.state], button.x, button.y, 0, button.width / buttonState[button.state]:getWidth(), button.height / buttonState[button.state]:getHeight())
        love.graphics.printf(button.text, button.x, button.y + (button.height / 2 - 10), button.width, "center")
    end
end

function menu.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        for _, btn in ipairs(buttons) do
            if x > btn.x and x < btn.x + btn.width and y > btn.y and y < btn.y + btn.height then
                btn.onClick()
            end
        end
    end
end

function menu.keypressed(key)
    if key == "return" then
        gameState = "game"
        game.load()
    end
end

return menu
