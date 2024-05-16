local game = require("game")

function love.load()
    game.load()
    love.window.setMode(1920, 1080)
    love.window.setTitle("Fenêtre avec Image")
    -- sound = love.audio.newSource("music.ogg", "stream")
    -- love.audio.play(sound)
end

function love.update(dt)
    game.update(dt)
end

function love.draw()
    game.draw()
end
