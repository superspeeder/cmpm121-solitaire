---@class Deck
---@field cards Card[]
---@field drawPile DrawPile
Deck = {}
Deck.mt = {__index=Deck}

---Create a new deck (unshuffled)
---@param drawPile DrawPile
---@return Deck
function Deck:new(drawPile)
    local deck = {}
    setmetatable(deck, Deck.mt)
    deck.cards = {}
    deck.drawPile = drawPile
    for _, suit in pairs(SUITS) do
        for rank=1,13 do
            table.insert(deck.cards, Card:new(suit, rank))
        end
    end
    return deck
end

---Draw several cards
---@param count integer
---@return Card[]
function Deck:drawMany(count)
    local cards = {}
    for _=1,math.min(count,#self.cards) do
        table.insert(cards, self:drawCard())
    end
    return cards
end

---Draw a card
---@return Card?
function Deck:drawCard()
    if #self.cards == 0 then
        return nil
    end
    
    local card = self.cards[#self.cards]
    table.remove(self.cards, #self.cards)
    return card
end

---Place a card on top of the deck
---@param card Card
function Deck:placeOnTop(card)
    table.insert(self.cards, card)
end

---Place a card on bottom of the deck
---@param card Card
function Deck:placeOnBottom(card)
    table.insert(self.cards, 1, card)
end

---Shuffle the deck
function Deck:shuffle()
    local cards = {}
    while #self.cards > 0 do
        local index = love.math.random(1, #self.cards)
        local card = self.cards[index]
        table.remove(self.cards, index)
        table.insert(cards, card)
    end
    self.cards = cards
end

---Draw
---@param dt number
---@param position Vector
function Deck:draw(dt, position)
    love.graphics.push()
    love.graphics.translate(position.x, position.y)

    love.graphics.setColor(SUIT_PILE_EMPTY_BG_COLOR)
    love.graphics.setLineWidth(4)
    love.graphics.rectangle("line", 0, 0, Card.width, Card.height, 6, 6)

    for i, card in ipairs(self.cards) do
        card:draw(Vector:new(0, (i - 1) * DECK_CARD_SEPERATION), dt, false)
    end

    love.graphics.pop()
end

---Use a snap point as a base to allow cards to be drawn from the deck by clicking on it
---@class DeckClickPoint: SnapPoint
---@field deck Deck
---@field drawPile DrawPile
DeckClickPoint = {}
DeckClickPoint.mt = {__index=DeckClickPoint}
setmetatable(DeckClickPoint, SnapPoint.mt)

---@class DeckEntity: Entity
---@field deck Deck
---@field position Vector
---@field snapPoint DeckClickPoint
DeckEntity = {}
DeckEntity.mt = {__index=DeckEntity}
setmetatable(DeckEntity, Entity.mt)

function DeckEntity:new(deck, position)
    local entity = {}
    setmetatable(entity, DeckEntity.mt)
    entity.deck = deck
    entity.position = position
    entity.snapPoint = DeckClickPoint:new(position, deck, deck.drawPile)
    return entity
end

function DeckEntity:draw(dt)
    self.deck:draw(dt, self.position)
end

function DeckEntity:update(dt)
    self.snapPoint.position = self.position + Vector:new(0, (#self.deck.cards - 1) * DECK_CARD_SEPERATION)
end

function DeckEntity:getSnapPoint()
    return self.snapPoint
end

function DeckClickPoint:new(position, deck, drawPile)
    local dcp = {}
    setmetatable(dcp, DeckClickPoint.mt)
    dcp.position = position
    dcp.deck = deck
    dcp.drawPile = drawPile
    return dcp
end

function DeckClickPoint:canPlaceCard(card)
    return false
end

function DeckClickPoint:clickedEmpty(point)
    if #self.deck.cards <= 0 then
        for i=1,#self.drawPile.cards do
            self.deck:placeOnBottom(self.drawPile.cards[i])
        end
        self.drawPile.cards = {}
    else
        local cards = self.deck:drawMany(3)

        for _, c in ipairs(cards) do
            table.insert(self.drawPile.cards, c)
        end
    end

    return true
end
