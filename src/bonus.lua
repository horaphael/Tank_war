local spawnBonus = {}

function spawnBonus(bonus_bullet, bonus_speed)
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()

    if not bonus_bullet.active then
        bonus_bullet.x = math.random(0, windowWidth - bonus_bullet.width)
        bonus_bullet.y = math.random(0, windowHeight - bonus_bullet.height)
    end

    if not bonus_speed.active then
        bonus_speed.x = math.random(0, windowWidth - bonus_speed.width)
        bonus_speed.y = math.random(0, windowHeight - bonus_speed.height)
    end
end

return spawnBonus