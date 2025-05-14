---@class Action
---@field movedObject Card | Tableau
---@field sourcePoint GrabPoint
---@field endPoint SnapPoint
---@field flippedCard boolean
Action = {}
Action.mt = {__index=Action}


function Action:new(movedObject, sourcePoint, endPoint, flippedCard)
    local o = {}
    setmetatable(o, Action.mt)
    o.movedObject = movedObject
    o.sourcePoint = sourcePoint
    o.endPoint = endPoint
    o.flippedCard = flippedCard
    return o
end

-- TODO: implement how this works (bit of rework again)

---Do the action
function Action:run()
    self.endPoint:placeCard(self.movedObject)
    self.sourcePoint:take(self.movedObject)
end

---Undo the action
function Action:undo()
    self.sourcePoint:placeCard(self.movedObject)
    self.endPoint:take(self.movedObject)
end


