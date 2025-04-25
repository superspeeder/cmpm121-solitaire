---@class Grab: Entity
---@field grabbedCard? Card | Tableau
---@field grabOrigin? GrabPoint
Grab = {}
Grab.mt = {__index=Grab}

GRAB_JUMP = 10

setmetatable(Grab, Entity.mt)

function Grab:new()
    local grab = {}
    setmetatable(grab, Grab.mt)
    return grab
end

function Grab:draw(dt)
    local mouseX, mouseY = love.mouse.getPosition()
    if self.grabbedCard ~= nil then
        self.grabbedCard:drawGrabbed(dt, Vector:new(mouseX, mouseY) - (self.grabOffset or Vector))
    end
end

function Grab:update(dt)
end

---Grab from a grab point
---@param grabPoint GrabPoint
---@param mousePosition Vector
function Grab:grab(grabPoint, mousePosition)
    self.grabbedCard = grabPoint:grab(mousePosition)
    self.grabOrigin = grabPoint
    self.grabOffset = mousePosition - grabPoint.position + Vector:new(0, GRAB_JUMP)
end

---Stop grabbing the object and try to drop it at a position
---@param position Vector
---@param snapPoint? SnapPoint if this is nil, then we aren't hovering over a snap point
function Grab:ungrab(position, snapPoint)
    if self.grabbedCard == nil then return end

    if snapPoint == nil then
        if self.grabOrigin ~= nil then
            self.grabOrigin:revertGrab(self.grabbedCard)
            self.grabbedCard = nil
        else
            error("Cannot ungrab a card when there is no grab origin")
        end
        return
    end

    if not snapPoint:canPlaceCard(self.grabbedCard) then
        if self.grabOrigin ~= nil then
            self.grabOrigin:revertGrab(self.grabbedCard)
            self.grabbedCard = nil
        else
            error("Cannot ungrab a card when there is no grab origin")
        end
        return
    end

    snapPoint:placeCard(self.grabbedCard)
    if self.grabOrigin ~= nil then
        self.grabOrigin:resolveGrab()
        self.grabOrigin = nil
    end
    self.grabbedCard = nil
end

---@class GrabPoint
---@field position Vector
GrabPoint = {}
GrabPoint.mt = {__index=GrabPoint}

function GrabPoint:new(position)
    local gp = {}
    setmetatable(gp, GrabPoint.mt)
    gp.position = position
    return gp
end

---Check if the grab point can be grabbed from with the given cursor position
---@param point any
function GrabPoint:canGrabFrom(point)
    return self.position.x <= point.x and point.x <= (self.position.x + Card.width) and self.position.y <= point.y and point.y <= (self.position.y + Card.height)
end

---Grab from this grab point
---@param point Vector the point where the mouse clicked
---@return Card | Tableau
function GrabPoint:grab(point)
    error("Cannot call the default grab point implementation") -- This function is abstract and is here to be overriden by subclasses which actually manage grabbing a card
end

---Called when a grab is failed
---@param grabObject Card | Tableau
function GrabPoint:revertGrab(grabObject)
    error("Cannot call the default grab point implementation") -- This function is abstract and is here to be overriden by subclasses which actually manage this
end

---Called when the grabbed card(s) are dropped somewhere (used to resolve the pending state of the tableau, which keeps cards from being flipped up prematurely)
function GrabPoint:resolveGrab()
end

---@class GenericGrabPoint: GrabPoint
---@field source table
GenericGrabPoint = {}
GenericGrabPoint.mt = {__index=GenericGrabPoint}
setmetatable(GenericGrabPoint, GrabPoint.mt)

function GenericGrabPoint:new(grabbableSource, position)
    local ggp = {}
    setmetatable(ggp, GenericGrabPoint.mt)
    ggp.source = grabbableSource
    ggp.position = position
    return ggp
end

function GenericGrabPoint:grab(point)
    return self.source:grab();
end

function GenericGrabPoint:revertGrab(grabObject)
    self.source:revertGrab(grabObject)
end

function GenericGrabPoint:resolveGrab()
    self.source:resolveGrab()
end
