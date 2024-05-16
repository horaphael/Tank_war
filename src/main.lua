local game = require("game")
local volume = 50
function love.load()
    game.load()
    love.window.setMode(1920, 1030)
    love.window.setTitle("Fenêtre avec Image")
    sound = love.audio.newSource("woo_scary.ogg", "stream")
    love.audio.setVolume(volume)
    -- love.audio.play(sound)
end

function love.update(dt)
    game.update(dt)
end

function love.draw()
    game.draw()
end

function love.keypressed(key)
    game.keypressed(key)
end