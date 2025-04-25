---@class Deck
---@field cards Card[]
Deck = {}
Deck.mt = {__index=Deck}

DECK_CARD_SEPERATION = -1

---Create a new deck (unshuffled)
---@return Deck
function Deck:new()
    local deck = {}
    setmetatable(deck, Deck.mt)
    deck.cards = {}
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
    for _=1,count do
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

    for i, card in ipairs(self.cards) do
        card:draw(Vector:new(0, (i - 1) * DECK_CARD_SEPERATION), dt, false)
    end

    love.graphics.pop()
end

---Use a snap point as a base to allow cards to be drawn from the deck by clicking on it
---@class DeckClickPoint: SnapPoint
DeckClickPoint = {}
DeckClickPoint.mt = {__index=DeckClickPoint}
setmetatable(DeckClickPoint, SnapPoint.mt)

---@class DeckEntity: Entity
---@field deck Deck
---@field position Vector
DeckEntity = {}
DeckEntity.mt = {__index=DeckEntity}
setmetatable(DeckEntity, Entity.mt)

function DeckEntity:new(deck, position)
    local entity = {}
    setmetatable(entity, DeckEntity.mt)
    entity.deck = deck
    entity.position = position
    return entity
end

function DeckEntity:draw(dt)
    self.deck:draw(dt, self.position)
end

