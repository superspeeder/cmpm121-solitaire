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
