require("vector")
require("card")
require("snap_point")

local entities = {}

function love.load()
    table.insert(entities, Card:new(Vector(200, 200), SUITS.HEARTS, 4))
end

function love.update(dt)
    for _, entity in ipairs(entities) do
        entity:update(dt)
    end
end

function love.draw(dt)
    for _, entity in ipairs(entities) do
        entity:draw(dt)
    end
end
