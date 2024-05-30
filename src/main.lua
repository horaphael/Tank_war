if pcall(require, "lldbugger") then require("lldbugger").start() end
io.stdout:setvbuf("no")

local game = require("game")
local settings = require("settings")
local menu = require("menu")

gameState = "loading"  -- "loading", "menu", "settings", "game", "pause"

local loadingFont
local loading_sprite
local loadingTimer = 0
local volume = 50

function setGameState(state)
    gameState = state
end

function love.load()
    love.window.setMode(1920, 1030)
    love.window.setTitle("Tank War")

    loadingFont = love.graphics.newFont(30)
    loading_sprite = love.graphics.newImage("assets/loading.png")
    sound = love.audio.newSource("assets/woo_scary.ogg", "stream")
    love.audio.setVolume(volume)
    love.audio.play(sound)

    menu.load()
end

function love.update(dt)
    if gameState == "loading" then
        loadingTimer = loadingTimer + dt
        if loadingTimer >= 2 then
            setGameState("menu")
        end
    elseif gameState == "menu" then
        menu.update(dt)
    elseif gameState == "settings" then
        settings.update(dt)
    elseif gameState == "game" then
        game.update(dt)
    end
end

function love.draw()
    if gameState == "loading" then
        love.graphics.setFont(loadingFont)
        love.graphics.draw(loading_sprite, 0, 0, 0, 0.76, 1)
        love.graphics.print("Chargement...", love.graphics.getWidth() - 240, love.graphics.getHeight() - 60)
    elseif gameState == "menu" then
        menu.draw()
    elseif gameState == "settings" then
        settings.draw()
    elseif gameState == "game" then
        game.draw()
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if gameState == "menu" then
        menu.mousepressed(x, y, button, istouch, presses)
    elseif gameState == "settings" then
        settings.mousepressed(x, y, button, istouch, presses)
    end
end

function love.keypressed(key)
    if gameState == "menu" then
        menu.keypressed(key)
    elseif gameState == "settings" and key == "escape" then
        setGameState("menu")
    elseif gameState == "game" then
        game.keypressed(key)
    end
end
