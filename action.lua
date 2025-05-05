---@class Action
---@field movedObject
---@field sourcePoint
---@field endPoint
Action = {}
Action.mt = {__index=Action}


function Action:new(movedObject, sourcePoint, endPoint)
    local o = {}
    setmetatable(o, Action.mt)
    o.movedObject = movedObject
    o.sourcePoint = sourcePoint
    o.endPoint = endPoint
    return o
end

-- TODO: implement how this works (bit of rework again)

---Do the action
function Action:run()
    self.endPoint.place(self.movedObject)
    self.sourcePoint.take(self.movedObject)
end

---Undo the action
function Action:undo()
    self.sourcePoint.place(self.movedObject)
    self.endPoint.take(self.movedObject)
end


