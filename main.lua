require("vector")
require("card")
require("snap_point")

local entities = {}

function love.load()
    Card.setupSprites();

    table.insert(entities, Card:new(Vector(100, 200), SUITS.HEARTS, 1))
    table.insert(entities, Card:new(Vector(200, 200), SUITS.SPADES, 2))
    table.insert(entities, Card:new(Vector(300, 200), SUITS.DIAMONDS, 3))
    table.insert(entities, Card:new(Vector(400, 200), SUITS.CLUBS, 4))
    table.insert(entities, Card:new(Vector(500, 200), SUITS.HEARTS, 5))
    table.insert(entities, Card:new(Vector(600, 200), SUITS.SPADES, 6))
    table.insert(entities, Card:new(Vector(100, 350), SUITS.DIAMONDS, 7))
    table.insert(entities, Card:new(Vector(200, 350), SUITS.CLUBS, 8))
    table.insert(entities, Card:new(Vector(300, 350), SUITS.HEARTS, 9))
    table.insert(entities, Card:new(Vector(400, 350), SUITS.SPADES, 10))
    table.insert(entities, Card:new(Vector(500, 350), SUITS.DIAMONDS, 11))
    table.insert(entities, Card:new(Vector(600, 350), SUITS.CLUBS, 12))
    table.insert(entities, Card:new(Vector(700, 350), SUITS.HEARTS, 13))
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
