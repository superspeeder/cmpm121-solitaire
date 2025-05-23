require("const")
require("vector")
require("entity")
require("card")
require("snap_point")
require("grab")
require("draw_pile")
require("deck")
require("tableau")
require("suit_pile")
require("button")


---@type Entity[]
local entities = {}

---@type DeckEntity
local deckEntity = nil

---@type SnapPoint?
local hoveredSnapPoint = nil

---@type SuitPile[]
local suitPiles = nil

---@type DrawPile
local drawPile = nil

---@type Grab
local grab = nil

local resetButton = nil

local hasWon = false

local newGameButton = nil
local quitButton = nil

function resetState()
    entities = {}
    grab = Grab:new()

    suitPiles = {
        [SUITS.HEARTS] = SuitPile:new(SUITS.HEARTS, Vector:new(650, 100)),
        [SUITS.DIAMONDS] = SuitPile:new(SUITS.DIAMONDS, Vector:new(650, 210)),
        [SUITS.SPADES] = SuitPile:new(SUITS.SPADES, Vector:new(650, 320)),
        [SUITS.CLUBS] = SuitPile:new(SUITS.CLUBS, Vector:new(650, 420))
    }

    drawPile = DrawPile:new(Vector:new(130, 100))
    table.insert(entities, drawPile)

    local deck = Deck:new(drawPile)
    deck:shuffle();

    table.insert(entities, DeckEntity:new(deck, Vector:new(50, 100)))

    table.insert(entities, Tableau:newFromHeight(1, deck, Vector:new(50, 250)))
    table.insert(entities, Tableau:newFromHeight(2, deck, Vector:new(130, 250)))
    table.insert(entities, Tableau:newFromHeight(3, deck, Vector:new(210, 250)))
    table.insert(entities, Tableau:newFromHeight(4, deck, Vector:new(290, 250)))
    table.insert(entities, Tableau:newFromHeight(5, deck, Vector:new(370, 250)))
    table.insert(entities, Tableau:newFromHeight(6, deck, Vector:new(450, 250)))
    table.insert(entities, Tableau:newFromHeight(7, deck, Vector:new(530, 250)))

    table.insert(entities, suitPiles[SUITS.HEARTS]);
    table.insert(entities, suitPiles[SUITS.SPADES]);
    table.insert(entities, suitPiles[SUITS.DIAMONDS]);
    table.insert(entities, suitPiles[SUITS.CLUBS]);

    table.insert(entities, grab)

    table.insert(entities, resetButton)
end

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    Card.setupSprites()

    resetButton = Button:new(Vector:new(650, 50), "Reset", function() resetState() end);
    newGameButton = Button:new(Vector(250, 350), "New Game", function() resetState(); hasWon = false; end)
    quitButton = Button:new(Vector(450, 350), "Quit", function() love.event.quit() end)

    resetState()

    love.graphics.setBackgroundColor(GAME_BACKGROUND)
end

function love.update(dt)
    local finishedPiles = 0;
    for _, sp in ipairs(suitPiles) do
        if sp:getTopRank() == 13 then
            finishedPiles = finishedPiles + 1;
        end
    end

    if finishedPiles == 4 then
        hasWon = true
        return
    end

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

    if hasWon then
        drawWinScreen()
    end
end

function grabhelper(mousePosition)
    for _, entity in ipairs(entities) do
        local eGrabPoints = entity:getGrabPoints()
        if eGrabPoints ~= nil then
            for _, gp in ipairs(eGrabPoints) do
                if gp:canGrabFrom(mousePosition) then
                    grab:grab(gp, mousePosition)
                    return true
                end
            end
        end
    end

    return false
end

function love.mousepressed(x, y)
    local mousePosition = Vector(x, y)

    if hasWon then
        newGameButton:click(mousePosition)
        quitButton:click(mousePosition)
        return
    end

    if grab.grabbedCard ~= nil then
        return -- if we are holding a card, do nothing
    end



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
        status = grabhelper(mousePosition)
    end

    if not status then
        for _, entity in ipairs(entities) do
            if entity:click(mousePosition) then
                status = true
                break
            end
        end
    end
end

function love.mousereleased(x, y)
    if hasWon then return end

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

function drawWinScreen()
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    newGameButton:draw()
    quitButton:draw()

    love.graphics.print("You Win!", 350 - love.graphics.getFont():getWidth("You Win!") / 2, 200, 0, 2, 2);
end

