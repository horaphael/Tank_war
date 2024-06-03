local game = {}

local Bullet = require("bullet")
local checkCollision = require("check_collision")
local move_player = require("move_player")
local spawnBonus = require("bonus")

local bullets = {}
local bullets2 = {}
local quads1 = {}
local quads2 = {}
local obstacles = {}

local buttons = {}
local buttonWidth = 300
local buttonHeight = 100
local buttonState = {
    normal = love.graphics.newImage("assets/Button/normal.png"),
    hover = love.graphics.newImage("assets/Button/hover.png"),
    pressed = love.graphics.newImage("assets/Button/pressed.png")
}

local animationSpeed = 0.1

local player1 = {
    shooting = false,
    currentFrame = 1,
    timer = 0,
    health = 10,
    isAlive = true,
    fireRate = 0.5,
    lastShotTime = 0,
    bonusActive = false,
    bonusTimer = 0
}

local player2 = {
    shooting = false,
    currentFrame = 1,
    timer = 0,
    health = 10,
    isAlive = true,
    fireRate = 0.5,
    lastShotTime = 0,
    bonusActive = false,
    bonusTimer = 0
}

local bonus_bullet = {
    x = 500,
    y = 300,
    width = 50,
    height = 50,
    active = true,
    duration = 5,
    respawn_timer = 0,
    respawn_delay = 5
}

local bonus_speed = {
    x = 800,
    y = 300,
    width = 50,
    height = 50,
    active = true,
    duration = 5,
    respawn_timer = 0,
    respawn_delay = 5
}

local keybinds = {
    shoot1 = "t",
    shoot2 = "m"
}

local isPaused = false
local gameOver = false
local winner = ""

function game.load()
    game.background = love.graphics.newImage("assets/back.jpg")
    game.player1 = love.graphics.newImage("assets/Blue/Bodies/body_tracks.png")
    game.player2 = love.graphics.newImage("assets/Red/Bodies/body_tracks.png")
    game.bonus_bullet_image = love.graphics.newImage("assets/Bonus/bonus_bullet.png")
    game.bonus_speed_image = love.graphics.newImage("assets/Bonus/bonus_speed.png")
    blueCanon = love.graphics.newImage("assets/Blue/Weapons/canon.png")
    redCanon = love.graphics.newImage("assets/Red/Weapons/canon.png")

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


    local spriteWidth = 128
    local spriteHeight = 100
    local numFrames = 8

    for i = 0, numFrames - 1 do
        quads1[i + 1] = love.graphics.newQuad(i * spriteWidth, 0, spriteWidth, spriteHeight, blueCanon:getDimensions())
        quads2[i + 1] = love.graphics.newQuad(i * spriteWidth, 0, spriteWidth, spriteHeight, redCanon:getDimensions())
    end

    buttons = {
        {
            x = love.graphics.getWidth() / 2 - buttonWidth / 2,
            y = love.graphics.getHeight() / 2 - buttonHeight,
            width = buttonWidth,
            height = buttonHeight,
            state = "normal",
            text = "Resume",
            onClick = function()
                isPaused = false
            end
        },
        {
            x = love.graphics.getWidth() / 2 - buttonWidth / 2,
            y = love.graphics.getHeight() / 2 - buttonHeight + 120,
            width = buttonWidth,
            height = buttonHeight,
            state = "normal",
            text = "Settings",
            onClick = function()
                isPaused = false
                gameState = "settings"
            end
        },
        {
            x = love.graphics.getWidth() / 2 - buttonWidth / 2,
            y = love.graphics.getHeight() / 2 - buttonHeight + 240,
            width = buttonWidth,
            height = buttonHeight,
            state = "normal",
            text = "Quit",
            onClick = function()
                isPaused = false
                gameState = "menu"
            end
        }
    }

    table.insert(obstacles, {x = 250, y = 600, width = 20, height = 200})
    table.insert(obstacles, {x = 1300, y = 150, width = 20, height = 200})
    lake = {x = 580, y = 150, width = 200, height = 350}
    lake2 = {x = 1150, y = 700, width = 300, height = 300}
    square = {x = 50, y = 800, width = 150, height = 150}
    square2 = {x = 1700, y = 50, width = 150, height = 150}
    spawnBonus(bonus_bullet, bonus_speed)
end

function game.update(dt)
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

    if gameOver or isPaused then
        return
    end

    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    local prev_player1_x = game.player1_x
    local prev_player1_y = game.player1_y
    local prev_player2_x = game.player2_x
    local prev_player2_y = game.player2_y


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

    for i, bullet in ipairs(bullets) do
        for j, obstacle in ipairs(obstacles) do
            if checkCollision(bullet, obstacle)  then
                table.remove(bullets, i)
                break
            end
        end
    end

    for i, bullet in ipairs(bullets2) do
        for j, obstacle in ipairs(obstacles) do
            if checkCollision(bullet, obstacle)  then
                table.remove(bullets2, i)
                break
            end
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

    if bonus_bullet.active then
        if checkCollision({x = game.player1_x, y = game.player1_y, width = game.player1:getWidth(), height = game.player1:getHeight()}, bonus_bullet) then
            bonus_bullet.active = false
            bonus_bullet.respawn_timer = bonus_bullet.respawn_delay
            player1.bonusActive = true
            player1.bonusTimer = bonus_bullet.duration
            player1.fireRate = 0.25
        elseif checkCollision({x = game.player2_x, y = game.player2_y, width = game.player2:getWidth(), height = game.player2:getHeight()}, bonus_bullet) then
            bonus_bullet.active = false
            bonus_bullet.respawn_timer = bonus_bullet.respawn_delay
            player2.bonusActive = true
            player2.bonusTimer = bonus_bullet.duration
            player2.fireRate = 0.25
        end
    else
        bonus_bullet.respawn_timer = bonus_bullet.respawn_timer - dt
        if bonus_bullet.respawn_timer <= 0 then
            spawnBonus(bonus_bullet, bonus_speed)
            bonus_bullet.active = true
        end
    end

    -- Vérification des collisions avec le bonus speed
    if bonus_speed.active then
        if checkCollision({x = game.player1_x, y = game.player1_y, width = game.player1:getWidth(), height = game.player1:getHeight()}, bonus_speed) then
            bonus_speed.active = false
            bonus_speed.respawn_timer = bonus_speed.respawn_delay
            player1.bonusActive = true
            player1.bonusTimer = bonus_speed.duration
            game.player1_speed = 300
        elseif checkCollision({x = game.player2_x, y = game.player2_y, width = game.player2:getWidth(), height = game.player2:getHeight()}, bonus_speed) then
            bonus_speed.active = false
            bonus_speed.respawn_timer = bonus_speed.respawn_delay
            player2.bonusActive = true
            player2.bonusTimer = bonus_speed.duration
            game.player2_speed = 300
        end
    else
        bonus_speed.respawn_timer = bonus_speed.respawn_timer - dt
        if bonus_speed.respawn_timer <= 0 then
            spawnBonus(bonus_bullet, bonus_speed)
            bonus_speed.active = true
        end
    end

    -- Gestion du bonus pour player1
    if player1.bonusActive then
        player1.bonusTimer = player1.bonusTimer - dt
        if player1.bonusTimer <= 0 then
            player1.bonusActive = false
            player1.fireRate = 0.5
            game.player1_speed = 150
        end
    end

    -- Gestion du bonus pour player2
    if player2.bonusActive then
        player2.bonusTimer = player2.bonusTimer - dt
        if player2.bonusTimer <= 0 then
            player2.bonusActive = false
            player2.fireRate = 0.5
            game.player2_speed = 150
        end
    end

    for _, obstacle in ipairs(obstacles) do
        if checkCollision({x = game.player1_x, y = game.player1_y, width = game.player1:getWidth(), height = game.player1:getHeight()}, obstacle) then
            game.player1_x = prev_player1_x
            game.player1_y = prev_player1_y
        end
    end

    for _, obstacle in ipairs(obstacles) do
        if checkCollision({x = game.player2_x, y = game.player2_y, width = game.player2:getWidth(), height = game.player2:getHeight()}, obstacle) then
            game.player2_x = prev_player2_x
            game.player2_y = prev_player2_y
        end
    end

    if checkCollision({x = game.player1_x, y = game.player1_y, width = game.player1:getWidth(), height = game.player1:getHeight()}, lake) then
        game.player1_x = prev_player1_x
        game.player1_y = prev_player1_y
    end

    if checkCollision({x = game.player2_x, y = game.player2_y, width = game.player2:getWidth(), height = game.player2:getHeight()}, lake) then
        game.player2_x = prev_player2_x
        game.player2_y = prev_player2_y
    end

    if checkCollision({x = game.player1_x, y = game.player1_y, width = game.player1:getWidth(), height = game.player1:getHeight()}, lake2) then
        game.player1_x = prev_player1_x
        game.player1_y = prev_player1_y
    end

    if checkCollision({x = game.player2_x, y = game.player2_y, width = game.player2:getWidth(), height = game.player2:getHeight()}, lake2) then
        game.player2_x = prev_player2_x
        game.player2_y = prev_player2_y
    end

    if checkCollision({x = game.player1_x, y = game.player1_y, width = game.player1:getWidth(), height = game.player1:getHeight()}, square) then
        game.player1_x = 1700
        game.player1_y = 300
    end
        
    if checkCollision({x = game.player2_x, y = game.player2_y, width = game.player2:getWidth(), height = game.player2:getHeight()}, square2) then
        game.player2_x = 50
        game.player2_y = 600
    end

    if checkCollision({x = game.player2_x, y = game.player2_y, width = game.player2:getWidth(), height = game.player2:getHeight()}, square) then
        game.player2_x = 1700
        game.player2_y = 300
    end
        
    if checkCollision({x = game.player2_x, y = game.player2_y, width = game.player2:getWidth(), height = game.player2:getHeight()}, square2) then
        game.player2_x = 50
        game.player2_y = 600
    end

end

function game.draw()
    love.graphics.draw(game.background, 0, 0, 0, game.scaleX, game.scaleY)

    if bonus_bullet.active then
        love.graphics.draw(game.bonus_bullet_image, bonus_bullet.x, bonus_bullet.y, 0, 0.5, 0.5)
    end

    if bonus_speed.active then
        love.graphics.draw(game.bonus_speed_image, bonus_speed.x, bonus_speed.y, 0, 0.2, 0.2)
    end

    if player1.isAlive then
        local centerX = game.player1:getWidth() / 2
        local centerY = game.player1:getHeight() / 2
        local cannonX1 = game.player1_x + centerX
        local cannonY1 = game.player1_y + centerY
        love.graphics.draw(game.player1, game.player1_x + centerX, game.player1_y + centerY, game.player1_rotation, 1, 1, centerX, centerY)
        love.graphics.draw(blueCanon, quads1[player1.currentFrame], cannonX1, cannonY1, math.rad(90), 1, 1, 64, 50)

        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", 10, 10, 500, 20)
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", 10, 10, 500 * (player1.health / 10), 20)
        love.graphics.setColor(1, 1, 1)
    end

    if player2.isAlive then
        local centerX2 = game.player2:getWidth() / 2
        local centerY2 = game.player2:getHeight() / 2
        local cannonX2 = game.player2_x + centerX2
        local cannonY2 = game.player2_y + centerY2
        love.graphics.draw(game.player2, game.player2_x + centerX2, game.player2_y + centerY2, game.player2_rotation, 1, 1, centerX2, centerY2)
        love.graphics.draw(redCanon, quads2[player2.currentFrame], cannonX2, cannonY2, math.rad(-90), 1, 1, 64, 50)

        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", 1410, 10, 500, 20)
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", 1410, 10, 500 * (player2.health / 10), 20)
        love.graphics.setColor(1, 1, 1)
    end

    for i, bullet in ipairs(bullets) do
        Bullet.draw(bullet)
    end

    for i, bullet in ipairs(bullets2) do
        Bullet.draw(bullet)
    end

    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", 250, 600, 20, 200)
    love.graphics.rectangle("fill", 1300, 150, 20, 200)

    love.graphics.setColor(0, 0, 1, 0.5)
    love.graphics.rectangle("fill", lake.x, lake.y, lake.width, lake.height)
    love.graphics.setColor(1, 1, 1)

    love.graphics.setColor(0, 0, 1, 0.5)
    love.graphics.rectangle("fill", lake2.x, lake2.y, lake2.width, lake2.height)
    love.graphics.setColor(1, 1, 1)

    love.graphics.setColor(0, 191/255, 255/255, 127/255)
    love.graphics.rectangle("fill", square.x, square.y, square.width, square.height)
    love.graphics.setColor(1, 1, 1)

    love.graphics.setColor(1, 0.5, 0)
    love.graphics.rectangle("fill", square2.x, square2.y, square2.width, square2.height)
    love.graphics.setColor(1, 1, 1)

    if gameOver then
        love.graphics.setColor(0.5, 0.5, 0.5, 0.7)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(winner .. " a gagné !", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
        love.graphics.printf("Appuyez sur 'R' pour recommencer", 0, love.graphics.getHeight() / 2 + 30, love.graphics.getWidth(), "center")
    end

    if isPaused then
        love.graphics.setColor(0.5, 0.5, 0.5, 0.7)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Pause", 0, buttonHeight + 20, love.graphics.getWidth(), "center")

        for _, button in ipairs(buttons) do
            love.graphics.draw(buttonState[button.state], button.x, button.y, 0, button.width / buttonState[button.state]:getWidth(), button.height / buttonState[button.state]:getHeight())
            love.graphics.printf(button.text, button.x, button.y + (button.height / 2 - 10), button.width, "center")
        end
    end
end

function game.keypressed(key)
    if key == "escape" then
        isPaused = not isPaused
        return
    end

    if gameOver then
        if key == "r" then
            game.restart()
        end return
    end

    if isPaused then
        return
    end

    local currentTime = love.timer.getTime()

    if key == keybinds.shoot1 and player1.isAlive and (currentTime - player1.lastShotTime >= player1.fireRate) then
        local bullet = Bullet.load(game.player1_x + game.player1:getWidth(), game.player1_y + game.player1:getHeight() / 2, 500)
        table.insert(bullets, bullet)
        player1.shooting = true
        player1.timer = 0
        player1.currentFrame = 2
        player1.lastShotTime = currentTime
    end

    if key == keybinds.shoot2 and player2.isAlive and (currentTime - player2.lastShotTime >= player2.fireRate) then
        local bullet = Bullet.load(game.player2_x, game.player2_y + game.player2:getHeight() / 2, -500)
        table.insert(bullets2, bullet)
        player2.shooting = true
        player2.timer = 0
        player2.currentFrame = 2
        player2.lastShotTime = currentTime
    end
end

function game.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        for _, btn in ipairs(buttons) do
            if x > btn.x and x < btn.x + btn.width and y > btn.y and y < btn.y + btn.height then
                btn.onClick()
            end
        end
    end
end

function game.restart()
    player1.shooting = false
    player1.currentFrame = 1
    player1.timer = 0
    player1.health = 10
    player1.isAlive = true
    player1.fireRate = 0.5
    player1.lastShotTime = 0
    player1.bonusActive = false
    player1.bonusTimer = 0

    player2.shooting = false
    player2.currentFrame = 1
    player2.timer = 0
    player2.health = 10
    player2.isAlive = true
    player2.fireRate = 0.5
    player2.lastShotTime = 0
    player2.bonusActive = false
    player2.bonusTimer = 0

    bullets = {}
    bullets2 = {}
    gameOver = false
    winner = ""

    game.player1_x = 100
    game.player1_y = 100
    game.player1_rotation = math.rad(90)
    game.player1_speed = 150

    game.player2_x = 1600
    game.player2_y = 800
    game.player2_rotation = math.rad(-90)
    game.player2_speed = 150

    bonus_bullet.active = true
    bonus_speed.active = true
    spawnBonus(bonus_bullet, bonus_speed)
end

return game
