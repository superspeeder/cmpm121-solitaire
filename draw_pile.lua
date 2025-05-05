---unlike most of the other piles, this one will be more flat and only render the top 3 cards of the pile (to prevent any weird layout issues)
---@class DrawPile: Entity
---@field cards Card[]
---@field position Vector
---@field pending boolean
DrawPile = {}
DrawPile.mt = {__index=DrawPile}
setmetatable(DrawPile, Entity.mt)

function DrawPile:new(position)
    local pile = {}
    setmetatable(pile, DrawPile.mt)
    pile.position = position
    pile.cards = {}
    pile.pending = false
    pile.firstRenderedCard = 1
    return pile
end

function DrawPile:update(dt)
    if self.pending then return end
    self.firstRenderedCard = math.max(1, #self.cards - 2)
end

function DrawPile:draw(dt)
    love.graphics.push()
    love.graphics.translate(self.position.x, self.position.y)

    for i=self.firstRenderedCard,#self.cards do
        self.cards[i]:draw(Vector:new((i - self.firstRenderedCard) * DRAW_PILE_CARD_SEPERATION, 0), dt, true)
    end
    love.graphics.pop()
end

function DrawPile:getGrabPoints()
    if #self.cards > 0 then
        return {GenericGrabPoint:new(self, Vector:new(math.min((#self.cards - 1) * DRAW_PILE_CARD_SEPERATION, 2 * DRAW_PILE_CARD_SEPERATION) + self.position.x, self.position.y))}
    end
    return {}
end

---Grab the top card
---@return Card
function DrawPile:grab()
    local card = self.cards[#self.cards]
    table.remove(self.cards, #self.cards)
    self.pending = true
    return card
end

---Called when a grab is failed
---we can assume the object is a card because logically we can never have a non-card object with this as the grab origin
---@param grabObject Card
function DrawPile:revertGrab(grabObject)
    table.insert(self.cards, grabObject)
    self.pending = false
end

function DrawPile:resolveGrab()
    self.pending = false
end


