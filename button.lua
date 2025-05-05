---@class Button: Entity
---@field position Vector
---@field text string
---@field onClick fun()
---@field size Vector
Button = {}
Button.mt = {__index=Button}
setmetatable(Button, Entity.mt)

local PADDING = 6
local BUTTON_OUTLINE_COLOR = {1,1,1}--{0.050980392156862744, 0.27058823529411763, 0.07058823529411765}
local BUTTON_FILL_COLOR = {0.8392156862745098, 0.30980392156862746, 0.30980392156862746,1}

function Button:new(position, text, onClick)
    local o = {}
    setmetatable(o, Button.mt)
    o.position = position
    o.text = text
    o.onClick = onClick
    o.size = Vector:new(love.graphics.getFont():getWidth(text), love.graphics.getFont():getHeight())
    return o
end

function Button:draw(dt)
    love.graphics.push()
    love.graphics.translate(self.position.x, self.position.y)
    love.graphics.setLineWidth(3)
    love.graphics.setColor(BUTTON_FILL_COLOR)
    love.graphics.rectangle("fill", 0, 0, self.size.x + PADDING * 2, self.size.y + PADDING * 2)
    love.graphics.setColor(BUTTON_OUTLINE_COLOR)
    love.graphics.rectangle("line", 0, 0, self.size.x + PADDING * 2, love.graphics.getFont():getHeight() + PADDING * 2)
    love.graphics.print(self.text, PADDING, PADDING);
    love.graphics.pop()
end

function Button:update(dt)
    self.size = Vector:new(love.graphics.getFont():getWidth(self.text), love.graphics.getFont():getHeight())
end

---@param mousePosition Vector
---@return boolean
function Button:click(mousePosition)
    if mousePosition.x >= self.position.x and mousePosition.y >= self.position.y and mousePosition.x <= self.position.x + self.size.x and mousePosition.y <= self.position.y + self.size.y then
        self.onClick();
        return true
    end

    return false
end