local move_player = {}

function move_player.moveplayer1(game, windowWidth, windowHeight, dt)
    if love.keyboard.isDown('z') and game.player1_y > 0 then
        game.player1_rotation = math.rad(180)
        game.player1_y = game.player1_y - game.player1_speed * dt  
    end
    if love.keyboard.isDown('s') and game.player1_y < windowHeight - game.player1:getHeight() then
        game.player1_rotation = math.rad(360)
        game.player1_y = game.player1_y + game.player1_speed * dt
    end
    if love.keyboard.isDown('q') and game.player1_x > 0 then
        game.player1_rotation = math.rad(90)
        game.player1_x = game.player1_x - game.player1_speed * dt
    end
    if love.keyboard.isDown('d') and game.player1_x < windowWidth - game.player1:getWidth() then
        game.player1_rotation = math.rad(-90)
        game.player1_x = game.player1_x + game.player1_speed * dt
    end
end

function move_player.moveplayer2(game, windowWidth, windowHeight, dt)
    if love.keyboard.isDown("up") and game.player2_y > 0 then
        game.player2_rotation = math.rad(180)
        game.player2_y = game.player2_y - game.player2_speed * dt
    end
    if love.keyboard.isDown("down") and game.player2_y < windowHeight - game.player2:getHeight() then
        game.player2_rotation = math.rad(360)
        game.player2_y = game.player2_y + game.player2_speed * dt
    end
    if love.keyboard.isDown("left") and game.player2_x > 0 then
        game.player2_rotation = math.rad(90)
        game.player2_x = game.player2_x - game.player2_speed * dt
    end
    if love.keyboard.isDown("right") and game.player2_x < windowWidth - game.player2:getWidth() then
        game.player2_rotation = math.rad(-90)
        game.player2_x = game.player2_x + game.player2_speed * dt
    end
end

return move_player
