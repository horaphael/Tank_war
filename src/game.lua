local game = {}

function game.load()
    game.image = love.graphics.newImage("back.jpg")
    game.player1 = love.graphics.newImage("tank.png")
    game.player2 = love.graphics.newImage("tank.png")

    game.scaleX = 3.5
    game.scaleY = 2

    game.player1_x = 100
    game.player1_y = 100
    game.player1_speed = 200
    game.player1_rotation = 0

    game.player2_x = 1600
    game.player2_y = 100
    game.player2_speed = 200
    game.player2_rotation = 0
end

function game.update(dt)
    -- FAIRE BOUGER LE PLAYER 1
    if love.keyboard.isDown('z') then
        game.player1_rotation = math.rad(180)
        game.player1_y = game.player1_y - game.player1_speed * dt  
    end
    if love.keyboard.isDown('s') then
        game.player1_rotation = math.rad(360)
        game.player1_y = game.player1_y + game.player1_speed * dt
    end
    if love.keyboard.isDown('q') then
        game.player1_rotation = math.rad(90)
        game.player1_x = game.player1_x - game.player1_speed * dt
    end
    if love.keyboard.isDown('d') then
        game.player1_rotation = math.rad(-90)
        game.player1_x = game.player1_x + game.player1_speed * dt
    end

    -- FAIRE BOUGER LE PLAYER 2
    if love.keyboard.isDown("up") then
        game.player2_rotation = math.rad(180)
        game.player2_y = game.player2_y - game.player2_speed * dt
    end
    if love.keyboard.isDown("down") then
        game.player2_rotation = math.rad(360)
        game.player2_y = game.player2_y + game.player2_speed * dt
    end
    if love.keyboard.isDown("left") then
        game.player2_rotation = math.rad(90)
        game.player2_x = game.player2_x - game.player2_speed * dt
    end
    if love.keyboard.isDown("right") then
        game.player2_rotation = math.rad(-90)
        game.player2_x = game.player2_x + game.player2_speed * dt
    end
end


function game.draw()
    local centerX = game.player1:getWidth() / 2
    local centerY = game.player1:getHeight() / 2

    local centerX2 = game.player2:getWidth() / 2
    local centerY2 = game.player2:getHeight() / 2

    love.graphics.draw(game.image, 0, 0, 0, game.scaleX, game.scaleY)
    love.graphics.draw(game.player1, game.player1_x + centerX, game.player1_y + centerY, game.player1_rotation, 1, 1, centerX, centerY)
    love.graphics.draw(game.player2, game.player2_x + centerX2, game.player2_y + centerY2, game.player2_rotation, 1, 1, centerX2, centerY2)
end

return game
