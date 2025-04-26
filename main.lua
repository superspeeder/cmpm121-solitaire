require("magic") 
require("vector")
require("entity")
require("card")
require("snap_point")
require("grab")
require("draw_pile")
require("deck")
require("tableau")
require("suit_pile")

GAME_BACKGROUND = {0.0784313725490196, 0.4392156862745098, 0.10980392156862745}

---@type Entity[]
local entities = {}

---@type DeckEntity
local deckEntity = nil

---@type SnapPoint?
local hoveredSnapPoint = nil

---@type SuitPile[]
local suitPiles = {
    [SUITS.HEARTS] = SuitPile:new(SUITS.HEARTS, Vector:new(650, 50)),
    [SUITS.DIAMONDS] = SuitPile:new(SUITS.DIAMONDS, Vector:new(650, 160)),
    [SUITS.SPADES] = SuitPile:new(SUITS.SPADES, Vector:new(650, 270)),
    [SUITS.CLUBS] = SuitPile:new(SUITS.CLUBS, Vector:new(650, 380))
}

---@type DrawPile
local drawPile = nil

---@type Grab
local grab = nil

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    Card.setupSprites()

    grab = Grab:new()

    drawPile = DrawPile:new(Vector:new(130, 50))
    table.insert(entities, drawPile)

    local deck = Deck:new(drawPile)
    deck:shuffle();

    table.insert(entities, DeckEntity:new(deck, Vector:new(50, 50)))

    table.insert(entities, Tableau:newFromHeight(1, deck, Vector:new(50, 200)))
    table.insert(entities, Tableau:newFromHeight(2, deck, Vector:new(130, 200)))
    table.insert(entities, Tableau:newFromHeight(3, deck, Vector:new(210, 200)))
    table.insert(entities, Tableau:newFromHeight(4, deck, Vector:new(290, 200)))
    table.insert(entities, Tableau:newFromHeight(5, deck, Vector:new(370, 200)))
    table.insert(entities, Tableau:newFromHeight(6, deck, Vector:new(450, 200)))
    table.insert(entities, Tableau:newFromHeight(7, deck, Vector:new(530, 200)))

    table.insert(entities, suitPiles[SUITS.HEARTS]);
    table.insert(entities, suitPiles[SUITS.SPADES]);
    table.insert(entities, suitPiles[SUITS.DIAMONDS]);
    table.insert(entities, suitPiles[SUITS.CLUBS]);

    table.insert(entities, grab)

    love.graphics.setBackgroundColor(GAME_BACKGROUND)
end

function love.update(dt)
    for _, entity in ipairs(entities) do
        entity:update(dt)
    end

    local x,y = love.mouse.getPosition()
    local mousePosition = {x=x,y=y}

    -- TODO: only do this when we are holding a card
    hoveredSnapPoint = nil
    for _, entity in ipairs(entities) do
        local snapPoint = entity:getSnapPoint()
        if snapPoint ~= nil and snapPoint:containsPoint(mousePosition) then
            hoveredSnapPoint = snapPoint
        end
    end
end

function love.draw(dt)
    for _, entity in ipairs(entities) do
        entity:draw(dt)
    end

    if hoveredSnapPoint ~= nil and grab.grabbedCard ~= nil then
        hoveredSnapPoint:drawOverlay()
    end
end

function grabhelper(mousePosition)
    for _, entity in ipairs(entities) do
        local eGrabPoints = entity:getGrabPoints()
        if eGrabPoints ~= nil then
            for _, gp in ipairs(eGrabPoints) do
                if gp:canGrabFrom(mousePosition) then
                    grab:grab(gp, mousePosition)
                    return
                end
            end
        end
    end
end

function love.mousepressed(x, y)
    if grab.grabbedCard ~= nil then
        return -- if we are holding a card, do nothing
    end


    local mousePosition = Vector(x, y)

    for _, entity in ipairs(entities) do
        local snapPoint = entity:getSnapPoint()
        if snapPoint ~= nil and snapPoint:containsPoint(mousePosition) then
            hoveredSnapPoint = snapPoint
        end
    end

    local status = false
    if hoveredSnapPoint ~= nil then
        status = hoveredSnapPoint:clickedEmpty(Vector:new(x, y))
    end

    if not status then
        grabhelper(mousePosition)
    end
end

function love.mousereleased(x, y)
    local mousePosition = Vector(x, y)

    for _, entity in ipairs(entities) do
        local snapPoint = entity:getSnapPoint()
        if snapPoint ~= nil and snapPoint:containsPoint(mousePosition) then
            hoveredSnapPoint = snapPoint
        end
    end

    if grab.grabbedCard ~= nil then
        grab:ungrab(mousePosition, hoveredSnapPoint)
    end
end