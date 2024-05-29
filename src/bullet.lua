local Bullet = {}

function Bullet.load(startX, startY, speed)
    local bullet = {}

    bullet.sprite = love.graphics.newImage("assets/bullet.png")
    bullet.x = startX
    bullet.y = startY
    bullet.width = 15
    bullet.height = 5
    bullet.speed = speed
    bullet.scaleX = 0.075
    bullet.scaleY = 0.075
    return bullet
end

function Bullet.update(bullet, dt)
    bullet.x = bullet.x + bullet.speed * dt
end

function Bullet.draw(bullet)
    love.graphics.draw(bullet.sprite, bullet.x, bullet.y, 0, bullet.scaleY)
end

return Bullet
