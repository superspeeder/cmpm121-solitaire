---@class SuitPile: Entity
---@field position Vector
---@field suit Suit
---@field cards Card[]
---@field snapPoint SnapPoint
SuitPile = {}
SuitPile.mt = {__index=SuitPile}
setmetatable(SuitPile, Entity.mt)

---Specialized snap point for suit piles
---@class SuitPileSnapPoint: SnapPoint
---@field pile SuitPile
SuitPileSnapPoint = {}
SuitPileSnapPoint.mt = {__index=SuitPileSnapPoint}
setmetatable(SuitPileSnapPoint, SnapPoint.mt)

function SuitPile:new(suit, position)
    local pile = {}
    setmetatable(pile, SuitPile.mt)
    pile.suit = suit
    pile.position = position
    pile.cards = {}
    pile.snapPoint = SuitPileSnapPoint:new(position, pile);

    return pile
end

function SuitPile:draw(dt)
    love.graphics.push()
    love.graphics.translate(self.position.x, self.position.y)

    if #self.cards > 0 then
        for i, card in ipairs(self.cards) do
            card:draw(Vector:new(0, (i - 1) * DECK_CARD_SEPERATION), dt, true)
        end
    else
        love.graphics.setColor(SUIT_PILE_EMPTY_BG_COLOR)
        love.graphics.setLineWidth(4)
        love.graphics.rectangle("line", 0, 0, Card.width, Card.height, 6, 6)
        love.graphics.setColor(SUIT_PILE_ICON_COLOR[self.suit])
        love.graphics.draw(Card.sprites[self.suit], 24, 40, 0, 2, 2)
    end

    love.graphics.pop()
end

function SuitPile:update(dt)
    if #self.cards > 0 then
        self.snapPoint.position = Vector:new(self.position.x, self.position.y + #self.cards * DECK_CARD_SEPERATION)
    else
        self.snapPoint.position = self.position
    end
end

function SuitPile:getSnapPoint()
    if self:getTopRank() == 13 then return nil end
    return self.snapPoint
end

---Get the rank of the top card in the pile
---@return integer
function SuitPile:getTopRank()
    if #self.cards > 0 then
        return self.cards[#self.cards].rank
    else
        return 0
    end
end

function SuitPile:getGrabPoints()
    if #self.cards > 0 then
        return {GenericGrabPoint:new(self, self.position + Vector(0, DECK_CARD_SEPERATION * (#self.cards - 1)))}
    end
end

function SuitPile:grab(point)
    local card = self.cards[#self.cards]
    table.remove(self.cards, #self.cards)
    return card
end

function SuitPile:revertGrab(grabObject)
    table.insert(self.cards, grabObject)
end

function SuitPile:resolveGrab() -- unlike the other things, there is no recurring logic for the suit piles that must be resumed when a grab resolves
end



function SuitPileSnapPoint:new(position, pile)
    local sp = {}
    setmetatable(sp, SuitPileSnapPoint.mt)
    sp.position = position
    sp.pile = pile
    return sp
end

function SuitPileSnapPoint:canPlaceCard(card)
    return card.suit == self.pile.suit and self.pile:getTopRank() + 1 == card.rank
end

function SuitPileSnapPoint:placeCard(card)
    table.insert(self.pile.cards, card)
end
