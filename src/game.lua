local Player = require("player")
local Bullet = require("bullet")

local Game = {}

local player1
local player2
local bullets = {}
local bullets2 = {}
local background
local gameOver = false
local winner

function Game.load()
    love.window.setTitle("Déplacement de deux carrés avec une image")
    love.window.setMode(800, 600)
    
    player1 = Player.load("tank.png", 100, 100, 5)
    player1.controls = {right = "d", left = "q", down = "s", up = "z"}

    player2 = Player.load("tank.png", 620, 100, 5)
    player2.controls = {right = "right", left = "left", down = "down", up = "up"}

    background = love.graphics.newImage("back.png")
end

function Game.update(dt)
    if not gameOver then
        Player.update(player1, dt)
        Player.update(player2, dt)

        for i, bullet in ipairs(bullets) do
            Bullet.update(bullet, dt)
            if bullet.x > love.graphics.getWidth() then
                table.remove(bullets, i)
            elseif checkCollision(bullet, player2) then
                table.remove(bullets, i)
                player2.lives = player2.lives - 1
                if player2.lives <= 0 then
                    player2.isAlive = false
                    gameOver = true
                    winner = "Joueur 1"
                end
            end
        end

        for i, bullet in ipairs(bullets2) do
            Bullet.update(bullet, dt)
            if bullet.x < 0 then
                table.remove(bullets2, i)
            elseif checkCollision(bullet, player1) then
                table.remove(bullets2, i)
                player1.lives = player1.lives - 1
                if player1.lives <= 0 then
                    player1.isAlive = false
                    gameOver = true
                    winner = "Joueur 2"
                end
            end
        end
    end
end

function Game.draw()
    love.graphics.clear()
    love.graphics.draw(background, 0, 0)

    Player.draw(player1)
    Player.draw(player2)

    love.graphics.setColor(1, 1, 1)

    love.graphics.print("Vies Joueur 1: " .. player1.lives, 10, 10)
    love.graphics.print("Vies Joueur 2: " .. player2.lives, 10, 30)

    for _, bullet in ipairs(bullets) do
        love.graphics.setColor(1, 0, 0)
        Bullet.draw(bullet)
        love.graphics.setColor(1, 1, 1)
    end

    for _, bullet in ipairs(bullets2) do
        love.graphics.setColor(1, 0, 0)
        Bullet.draw(bullet)
        love.graphics.setColor(1, 1, 1)
    end

    if gameOver then
        love.graphics.setColor(0.5, 0.5, 0.5, 0.7)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(winner .. " a gagné !", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - 50, love.graphics.getHeight() / 2 + 50, 100, 40)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Restart", 0, love.graphics.getHeight() / 2 + 70, love.graphics.getWidth(), "center")
    end
end

function Game.keypressed(key)
    if key == "t" then
        local bullet = Bullet.load(player1.x + player1.size, player1.y + player1.size / 2, 500)
        table.insert(bullets, bullet)
    end

    if key == "space" then
        local bullet = Bullet.load(player2.x - player2.size, player2.y + player2.size / 2, -500)
        table.insert(bullets2, bullet)
    end

    if gameOver and key == "r" then
        player1.lives = 5
        player2.lives = 5
        player1.isAlive = true
        player2.isAlive = true
        bullets = {}
        bullets2 = {}
        gameOver = false
    end
end

function checkCollision(a, b)
    return a.x < b.x + b.size and
           a.x + a.width > b.x and
           a.y < b.y + b.size and
           a.y + a.height > b.y
end

return Game
