local Bullet = {}

function Bullet.load(startX, startY, speed)
    local bullet = {}
    bullet.x = startX
    bullet.y = startY
    bullet.width = 15
    bullet.height = 5
    bullet.speed = speed
    return bullet
end

function Bullet.update(bullet, dt)
    bullet.x = bullet.x + bullet.speed * dt
end

function Bullet.draw(bullet)
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill", bullet.x, bullet.y, bullet.width, bullet.height)
    love.graphics.setColor(255, 255, 255)
end

return Bullet
