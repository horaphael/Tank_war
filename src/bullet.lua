local Bullet = {}

function Bullet.load(startX, startY, speed)
    local bullet = {}
    bullet.x = startX
    bullet.y = startY
    bullet.width = 10
    bullet.height = 5
    bullet.speed = speed
    return bullet
end

function Bullet.update(bullet, dt)
    bullet.x = bullet.x + bullet.speed * dt
end

function Bullet.draw(bullet)
    love.graphics.rectangle("fill", bullet.x, bullet.y, bullet.width, bullet.height)
end

return Bullet
