local Bullet = {}

function Bullet.load(startX, startY, speed, angle)
    local bullet = {}

    bullet.sprite = love.graphics.newImage("assets/bullet.png")
    bullet.x = startX
    bullet.y = startY
    bullet.width = 15
    bullet.height = 5
    bullet.speed = speed
    bullet.angle = angle
    bullet.scaleX = 0.075
    bullet.scaleY = 0.075
    bullet.velocityX = speed * math.cos(angle)
    bullet.velocityY = speed * math.sin(angle)

    return bullet
end

function Bullet.update(bullet, dt)
    bullet.x = bullet.x + bullet.velocityX * dt
    bullet.y = bullet.y + bullet.velocityY * dt
end

function Bullet.draw(bullet)
    love.graphics.draw(bullet.sprite, bullet.x, bullet.y, bullet.angle, bullet.scaleX, bullet.scaleY, bullet.sprite:getWidth() / 2, bullet.sprite:getHeight() / 2)
end

return Bullet
