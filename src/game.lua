local game = {}
local Bullet = require("bullet")
local bullets = {}
local canShoot = true
local move_player = require("move_player")
local spriteSheet
local quads = {}
local currentFrame = 1
local animationSpeed = 0.1
local timer = 0
local isShooting = false

function game.load()
    game.image = love.graphics.newImage("back.jpg")
    game.player1 = love.graphics.newImage("tank.png")
    game.player2 = love.graphics.newImage("tank.png")

    game.scaleX = 3.5
    game.scaleY = 2

    game.player1_x = 100
    game.player1_y = 100
    game.player1_speed = 200
    game.player1_rotation = math.rad(90)

    game.player2_x = 1600
    game.player2_y = 800
    game.player2_speed = 200
    game.player2_rotation = math.rad(-90)

    spriteSheet = love.graphics.newImage("turret_01_mk1.png")
    local spriteWidth = 128
    local spriteHeight = 100
    local numFrames = 8
    
    for i = 0, numFrames - 1 do
        quads[i + 1] = love.graphics.newQuad(i * spriteWidth, 0, spriteWidth, spriteHeight, spriteSheet:getDimensions())
    end
end

function game.update(dt)
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()

    -- FAIRE BOUGER LE PLAYER 1
    move_player.moveplayer1(game, windowWidth, windowHeight, dt)
    -- FAIRE BOUGER LE PLAYER 2
    move_player.moveplayer2(game, windowWidth, windowHeight, dt)

    -- Gestion des balles
    if love.keyboard.isDown('space') and canShoot then
        local bulletSpeed = 500
        local bulletStartX = game.player1_x + game.player1:getWidth() / 2
        local bulletStartY = game.player1_y + game.player1:getHeight() / 2
        local newBullet = Bullet.load(bulletStartX, bulletStartY, bulletSpeed)
        table.insert(bullets, newBullet)
        canShoot = false
        isShooting = true
        timer = 0
        currentFrame = 1
    elseif not love.keyboard.isDown('space') then
        canShoot = true
    end

    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        Bullet.update(bullet, dt)
        if bullet.x > love.graphics.getWidth() then
            table.remove(bullets, i)
        end
    end

    -- Mise à jour de l'animation du canon
    if isShooting then
        timer = timer + dt
        if timer >= animationSpeed then
            timer = timer - animationSpeed
            currentFrame = currentFrame + 1
            if currentFrame > #quads then
                currentFrame = 1
                isShooting = false
            end
        end
    end
end

function game.draw()
    local centerX = game.player1:getWidth() / 2
    local centerY = game.player1:getHeight() / 2
    local centerX2 = game.player2:getWidth() / 2
    local centerY2 = game.player2:getHeight() / 2

    love.graphics.draw(game.image, 0, 0, 0, game.scaleX, game.scaleY)
    
    -- le premier tank avec le canon
    local cannonX1 = game.player1_x + centerX
    local cannonY1 = game.player1_y + centerY
    love.graphics.draw(game.player1, game.player1_x + centerX, game.player1_y + centerY, game.player1_rotation, 1, 1, centerX, centerY)
    love.graphics.draw(spriteSheet, quads[currentFrame], cannonX1, cannonY1, math.rad(90), 1, 1, 64, 50)

    -- le deuxième tank avec le canon
    local cannonX2 = game.player2_x + centerX2
    local cannonY2 = game.player2_y + centerY2
    love.graphics.draw(game.player2, game.player2_x + centerX2, game.player2_y + centerY2, game.player2_rotation, 1, 1, centerX2, centerY2)
    love.graphics.draw(spriteSheet, quads[currentFrame], cannonX2, cannonY2, math.rad(90), 1, 1, 64, 50)

    -- les balles
    for i, bullet in ipairs(bullets) do
        Bullet.draw(bullet)
    end
end

return game