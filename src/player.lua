local Player = {}

function Player.load(imagePath, startX, startY, startLives)
    local player = {}
    player.image = love.graphics.newImage(imagePath)
    player.x = startX
    player.y = startY
    player.size = 30
    player.lives = startLives
    player.isAlive = true
    player.controls = {}
    return player
end

function Player.update(player, dt)
    if player.isAlive then
        if love.keyboard.isDown(player.controls.right) and player.x + player.size < love.graphics.getWidth() / 2 then
            player.x = player.x + 200 * dt
        end
        if love.keyboard.isDown(player.controls.left) and player.x > 0 then
            player.x = player.x - 200 * dt
        end
        if love.keyboard.isDown(player.controls.down) and player.y + player.size < love.graphics.getHeight() then
            player.y = player.y + 200 * dt
        end
        if love.keyboard.isDown(player.controls.up) and player.y > 0 then
            player.y = player.y - 200 * dt
        end
    end
end

function Player.draw(player)
    if player.isAlive then
        love.graphics.draw(player.image, player.x, player.y, 0, player.size / player.image:getWidth(), player.size / player.image:getHeight())
    end
end

return Player
