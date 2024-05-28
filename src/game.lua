local game = {}
local Bullet = require("bullet")
local bullets = {}
local bullets2 = {}
local canShoot = true
local move_player = require("move_player")
local quads1 = {}
local quads2 = {}
local animationSpeed = 0.1
local player1 = {
    shooting = false,
    currentFrame = 1,
    timer = 0,
    health = 5,
    isAlive = true
}
local player2 = {
    shooting = false,
    currentFrame = 1,
    timer = 0,
    health = 5,
    isAlive = true
}
local gameOver = false
local winner = ""

function game.load()
    game.image = love.graphics.newImage("assets/back.jpg")
    game.player1 = love.graphics.newImage("assets/Blue/Bodies/body_tracks.png") -- Player 1 tank sprite
    game.player2 = love.graphics.newImage("assets/Red/Bodies/body_tracks.png") -- Player 2 tank sprite

    game.scaleX = 3.5
    game.scaleY = 2

    game.player1_x = 100
    game.player1_y = 100
    game.player1_speed = 150
    game.player1_rotation = math.rad(90)

    game.player2_x = 1600
    game.player2_y = 800
    game.player2_speed = 150
    game.player2_rotation = math.rad(-90)

    -- Load turret sprites for each player
    spriteSheet1 = love.graphics.newImage("assets/Blue/Weapons/canon.png")
    spriteSheet2 = love.graphics.newImage("assets/Red/Weapons/canon.png")

    local spriteWidth = 128
    local spriteHeight = 100
    local numFrames = 8

    for i = 0, numFrames - 1 do
        quads1[i + 1] = love.graphics.newQuad(i * spriteWidth, 0, spriteWidth, spriteHeight, spriteSheet1:getDimensions())
        quads2[i + 1] = love.graphics.newQuad(i * spriteWidth, 0, spriteWidth, spriteHeight, spriteSheet2:getDimensions())
    end
end

function game.update(dt)
    if gameOver then
        return
    end

    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()

    if player1.isAlive then
        move_player.moveplayer1(game, windowWidth, windowHeight, dt)
    end
    if player2.isAlive then
        move_player.moveplayer2(game, windowWidth, windowHeight, dt)
    end

    -- Gestion des balles du joueur 1
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        Bullet.update(bullet, dt)
        -- Vérification des collisions avec le joueur 2
        if checkCollision(bullet, {x = game.player2_x, y = game.player2_y, width = game.player2:getWidth(), height = game.player2:getHeight()}) then
            table.remove(bullets, i)
            player2.health = player2.health - 1
            if player2.health <= 0 then
                player2.isAlive = false
                gameOver = true
                winner = "Player 1"
            end
        end
        if bullet.x > love.graphics.getWidth() then
            table.remove(bullets, i)
        end
    end

    -- Gestion des balles du joueur 2
    for i = #bullets2, 1, -1 do
        local bullet = bullets2[i]
        Bullet.update(bullet, dt)
        -- Vérification des collisions avec le joueur 1
        if checkCollision(bullet, {x = game.player1_x, y = game.player1_y, width = game.player1:getWidth(), height = game.player1:getHeight()}) then
            table.remove(bullets2, i)
            player1.health = player1.health - 1
            if player1.health <= 0 then
                player1.isAlive = false
                gameOver = true
                winner = "Player 2"
            end
        end
        if bullet.x < 0 then
            table.remove(bullets2, i)
        end
    end

    if player1.shooting then
        player1.timer = player1.timer + dt
        if player1.timer >= animationSpeed then
            player1.timer = player1.timer - animationSpeed
            player1.currentFrame = player1.currentFrame + 1
            if player1.currentFrame > #quads1 then
                player1.currentFrame = 1
                player1.shooting = false
            end
        end
    end

    if player2.shooting then
        player2.timer = player2.timer + dt
        if player2.timer >= animationSpeed then
            player2.timer = player2.timer - animationSpeed
            player2.currentFrame = player2.currentFrame + 1
            if player2.currentFrame > #quads2 then
                player2.currentFrame = 1
                player2.shooting = false
            end
        end
    end
end

function game.keypressed(key)
    if gameOver then
        if key == "r" then
            game.restart()
        end
        return
    end

    if key == "t" and player1.isAlive then
        local bullet = Bullet.load(game.player1_x + game.player1:getWidth(), game.player1_y + game.player1:getHeight() / 2, 500)
        table.insert(bullets, bullet)
        player1.shooting = true
        player1.timer = 0
        player1.currentFrame = 2
    end

    if key == "m" and player2.isAlive then
        local bullet = Bullet.load(game.player2_x, game.player2_y + game.player2:getHeight() / 2, -500)
        table.insert(bullets2, bullet)
        player2.shooting = true
        player2.timer = 0
        player2.currentFrame = 2
    end
end

function game.draw()
    love.graphics.draw(game.image, 0, 0, 0, game.scaleX, game.scaleY)
    if player1.isAlive then
        local centerX = game.player1:getWidth() / 2
        local centerY = game.player1:getHeight() / 2
        local cannonX1 = game.player1_x + centerX
        local cannonY1 = game.player1_y + centerY
        love.graphics.draw(game.player1, game.player1_x + centerX, game.player1_y + centerY, game.player1_rotation, 1, 1, centerX, centerY)
        love.graphics.draw(spriteSheet1, quads1[player1.currentFrame], cannonX1, cannonY1, math.rad(90), 1, 1, 64, 50)
        love.graphics.print("Vies Player 1: " .. player1.health, 10, 10)
    end
    if player2.isAlive then
        local centerX2 = game.player2:getWidth() / 2
        local centerY2 = game.player2:getHeight() / 2
        local cannonX2 = game.player2_x + centerX2
        local cannonY2 = game.player2_y + centerY2
        love.graphics.draw(game.player2, game.player2_x + centerX2, game.player2_y + centerY2, game.player2_rotation, 1, 1, centerX2, centerY2)
        love.graphics.draw(spriteSheet2, quads2[player2.currentFrame], cannonX2, cannonY2, math.rad(-90), 1, 1, 64, 50)
        love.graphics.print("Vies Player 2: " .. player2.health, 10, 30)
    end

    for i, bullet in ipairs(bullets) do
        Bullet.draw(bullet)
    end

    for i, bullet in ipairs(bullets2) do
        Bullet.draw(bullet)
    end

    if gameOver then
        love.graphics.setColor(0.5, 0.5, 0.5, 0.7)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(winner .. " a gagné !", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
        love.graphics.printf("Appuyez sur 'R' pour recommencer", 0, love.graphics.getHeight() / 2 + 30, love.graphics.getWidth(), "center")
    end
end

function game.restart()
    player1 = {
        shooting = false,
        currentFrame = 1,
        timer = 0,
        health = 5,
        isAlive = true
    }
    player2 = {
        shooting = false,
        currentFrame = 1,
        timer = 0,
        health = 5,
        isAlive = true
    }
    bullets = {}
    bullets2 = {}
    gameOver = false
    winner = ""

    game.player1_x = 100
    game.player1_y = 100
    game.player1_rotation = math.rad(90)

    game.player2_x = 1600
    game.player2_y = 800
    game.player2_rotation = math.rad(-90)
end

function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.width > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end

return game
