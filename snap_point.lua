---@class SnapPoint
---@field position Vector
---@field cardVerifier? fun(card: Card): boolean
SnapPoint = {}
SnapPoint.mt = {__index=SnapPoint}

SNAP_POINT_OVERLAY_COLOR = {0,0,0,0.2}

function SnapPoint:new(position)
    local snapPoint = {}
    setmetatable(snapPoint, SnapPoint.mt)
    snapPoint.position = true
    return snapPoint
end

---Check if a card can be placed on this snap point
---@param card Card | Tableau
---@return boolean
function SnapPoint:canPlaceCard(card)
    return true
end

---Draw the overlay for when you hover over this snap point
function SnapPoint:drawOverlay()
    love.graphics.setColor(SNAP_POINT_OVERLAY_COLOR)

    -- Use the default card width and height as the size for the snap point
    love.graphics.rectangle("fill", self.position.x, self.position.y, Card.width, Card.height, 6, 6)
end

---Check if a point is inside this snapPoint
---@param point {x: number, y: number}
---@return boolean
function SnapPoint:containsPoint(point)
    return point.x >= self.position.x and point.x <= (self.position.x + Card.width) and point.y >= self.position.y and point.y <= (self.position.y + Card.height)
end

---Base function for clicking a snap point without holding a card
---@return boolean status Did this function do anything? Used for passthrough control
function SnapPoint:clickedEmpty(point)
    return false
end

---Place a card in this snap point
---@param card Card | Tableau
function SnapPoint:placeCard(card)
    error("Cannot call the default snap point implementation") -- This function is abstract and is here to be overriden by subclasses which actually manage this
end