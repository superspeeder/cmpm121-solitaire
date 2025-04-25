---@class Tableau: Entity
---@field cards TableauEntry[]
---@field position Vector
---@field snapPoint SnapPoint
Tableau = {}
Tableau.mt = {__index=Tableau}
setmetatable(Tableau, Entity.mt)

STACK_SEPERATION = 20

---@class TableauEntry
---@field card Card
---@field faceUp boolean

---@param cards Card[]
---@param position Vector
---@return Tableau
function Tableau:new(cards, position)
    local tableau = {}
    setmetatable(tableau, Tableau.mt)
    tableau.cards = {}
    for _, card in ipairs(cards) do
        table.insert(tableau.cards, {card=card, faceUp=false})
    end
    tableau.position = position
    tableau.snapPoint = SnapPoint:new(Vector:new(position.x, #tableau.cards * STACK_SEPERATION + position.y))
    return tableau
end

---Create a new tableau by drawing a number of cards from a deck
---@param height integer
---@param deck Deck
---@param position Vector
---@return Tableau
function Tableau:newFromHeight(height, deck, position)
    return Tableau:new(deck:drawMany(height), position)
end

function Tableau:draw(dt)
    love.graphics.push()
    love.graphics.translate(self.position.x, self.position.y)
    for i, card in ipairs(self.cards) do
        card.card:draw(Vector:new(0, (i - 1) * STACK_SEPERATION), dt, card.faceUp)
    end
    love.graphics.pop()
end

function Tableau:update(dt)
    if #self.cards <= 0 then
        return
    end

    if not self.cards[#self.cards].faceUp then
        self.cards[#self.cards].faceUp = true
    end

    self.snapPoint.position = Vector:new(self.position.x, #self.cards * STACK_SEPERATION + self.position.y)
end

function Tableau:getSnapPoint()
    return self.snapPoint
end