---@class Tableau: Entity
---@field cards TableauEntry[]
---@field position Vector
---@field snapPoint TableauSnapPoint
---@field pending boolean
---@field grabOnly boolean
---@field magic integer
Tableau = {}
Tableau.mt = {__index=Tableau}
setmetatable(Tableau, Entity.mt)

---@class TableauEntry
---@field card Card
---@field faceUp boolean

---@param cards TableauEntry[]
---@param position Vector
---@param grabOnly? boolean is this tableau grab only (no logic, just rendering and data, used by stacks)
---@return Tableau
function Tableau:new(cards, position, grabOnly)
    local tableau = {}
    setmetatable(tableau, Tableau.mt)
    tableau.cards = cards
    tableau.position = position
    tableau.snapPoint = TableauSnapPoint:new(tableau, Vector:new(position.x, #tableau.cards * STACK_SEPERATION + position.y))
    tableau.magic = MAGIC_TABLEAU
    tableau.pending = false
    tableau.grabOnly = grabOnly or false
    return tableau
end

---Create a new tableau by drawing a number of cards from a deck
---@param height integer
---@param deck Deck
---@param position Vector
---@return Tableau
function Tableau:newFromHeight(height, deck, position)
    local cards = {}
    for _, card in ipairs(deck:drawMany(height)) do
        table.insert(cards, {card=card,faceUp=false})
    end
    return Tableau:new(cards, position)
end

function Tableau:draw(dt, shadowOffset)
    love.graphics.push()
    love.graphics.translate(self.position.x, self.position.y)
    for i, card in ipairs(self.cards) do
        card.card:draw(Vector:new(0, (i - 1) * STACK_SEPERATION), dt, card.faceUp, shadowOffset)
    end
    love.graphics.pop()
end

function Tableau:update(dt)
    self.snapPoint.position = Vector:new(self.position.x, #self.cards * STACK_SEPERATION + self.position.y)

    if self.pending or self.grabOnly then
        return
    end

    if #self.cards <= 0 then
        return
    end

    if not self.cards[#self.cards].faceUp then
        self.cards[#self.cards].faceUp = true
    end
end

function Tableau:getSnapPoint()
    if self.pending then return nil end
    return self.snapPoint
end

function Tableau:drawGrabbed(dt, position)
    self.position = position
    self:draw(dt, 4)
end

---Pick up a number of cards off the top of the tableau
---@param count integer
---@return Tableau | Card
function Tableau:pickUpCards(count)
    if count == 1 then
        local card = self.cards[#self.cards].card
        table.remove(self.cards, #self.cards)
        return card
    end


    local cards = {}
    for i=#self.cards-count+1,#self.cards do
        if self.cards[i].faceUp then
            table.insert(cards, self.cards[i])
        end
    end

    for i=1,#cards do
        table.remove(self.cards, #self.cards) -- remove the cards from this tableau (prevent card dupe)
    end

    return Tableau:new(cards, Vector:new(0, 0)) -- The caller has to set the position in order to make this work right
end

function Tableau:getGrabPoints()
    if self.grabOnly or self.pending then
        return {}
    end

    local grabPoints = {}
    for i=0,#self.cards-1 do
        if self.cards[#self.cards-i].faceUp then
            table.insert(grabPoints, TableauGrabPoint:new(self, i + 1))
        end
    end

    return grabPoints
end

---Place cards on top
---@param cards TableauEntry[]
function Tableau:placeCards(cards)
    for _, entry in ipairs(cards) do
        table.insert(self.cards, entry)
    end
end

---@class TableauGrabPoint: GrabPoint
---@field tableau Tableau
---@field count integer
TableauGrabPoint = {}
TableauGrabPoint.mt = {__index=TableauGrabPoint}
setmetatable(TableauGrabPoint, GrabPoint.mt)

---Create a new tableau grab point
---@param tableau Tableau
---@param n integer
function TableauGrabPoint:new(tableau, n)
    local tgp = {}
    setmetatable(tgp, TableauGrabPoint.mt)
    tgp.tableau = tableau
    tgp.count = n
    tgp.position = Vector(tableau.position.x, tableau.position.y + (#tableau.cards - n) * STACK_SEPERATION)
    return tgp
end

function TableauGrabPoint:grab(point)
    self.tableau.pending = true
    return self.tableau:pickUpCards(self.count)
end

function TableauGrabPoint:resolveGrab()
    self.tableau.pending = false
end

---Called when a grab fails
---@param grabObject Card | Tableau
function TableauGrabPoint:revertGrab(grabObject)
    
    self.tableau.pending = false

    if grabObject.magic == MAGIC_CARD then
        ---@type TableauEntry
        ---@cast grabObject Card
        local entry = {card=grabObject, faceUp=true}
        self.tableau:placeCards({entry})
    else
        ---@cast grabObject Tableau
        self.tableau:placeCards(grabObject.cards)
    end

end

---@class TableauSnapPoint: SnapPoint
---@field tableau Tableau
TableauSnapPoint = {}
TableauSnapPoint.mt = {__index = TableauSnapPoint}
setmetatable(TableauSnapPoint, SnapPoint.mt)

---@param tableau Tableau
---@param position Vector
function TableauSnapPoint:new(tableau, position)
    local sp = {}
    setmetatable(sp, TableauSnapPoint.mt)
    sp.tableau = tableau
    sp.position = position
    return sp
end

---Check if a card can be placed on this snap point
---@param card Card | Tableau
---@return boolean
function TableauSnapPoint:canPlaceCard(card)
    if card.magic == MAGIC_CARD then
        if #self.tableau.cards <= 0 then
            return card.rank == 13 -- only kings can be placed on empty tableaus
        end
        ---@cast card Card
        local topCard = self.tableau.cards[#self.tableau.cards].card;
        return topCard.rank - 1 == card.rank and topCard.suit % 2 ~= card.suit % 2 -- When we set up the suit enum we made it so that the same color has the same %2 value (odd numbers are red, even are black)
    else
        ---@cast card Tableau
        return self:canPlaceCard(card.cards[1].card) -- just check if the bottom card of the stack can be placed on this tableau
    end
end

---Place a card in this snap point
---@param card Card | Tableau
function TableauSnapPoint:placeCard(card)
    if card.magic == MAGIC_CARD then
        ---@type TableauEntry
        ---@cast card Card
        local entry = {card=card, faceUp=true}
        self.tableau:placeCards({entry})
    else
        ---@cast card Tableau
        self.tableau:placeCards(card.cards)
    end
end

