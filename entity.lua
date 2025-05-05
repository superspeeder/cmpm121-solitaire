---@class Entity
Entity = {}
Entity.mt = {__index=Entity}

---Default Entity draw function
---@param dt number
function Entity:draw(dt) end

---Default Entity update function
---@param dt number
function Entity:update(dt) end

---Default get snap point function
---@return SnapPoint?
function Entity:getSnapPoint() return nil end

---Default get grab points function
---Grab points should be returned in priority order (the first grab point in the list which is hovered when trying to grab should be the one to use. This means tableaus return in order from top to bottom card)
---@return GrabPoint[]
function Entity:getGrabPoints() return {} end

---Called when no other click handling method is called. Return true if a click is handled.
---@param mousePosition Vector
---@return boolean
function Entity:click(mousePosition) return false end