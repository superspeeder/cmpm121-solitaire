---@class Button: Entity
---@field position Vector
---@field text string
---@field onClick fun()
---@field size Vector
Button = {}
Button.mt = {__index=Button}
setmetatable(Button, Entity.mt)


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
    self.size = Vector:new(love.graphics.getFont():getWidth(self.text), love.graphics.getFont():getHeight())

    love.graphics.push()
    love.graphics.translate(self.position.x, self.position.y)
    love.graphics.setLineWidth(3)
    love.graphics.setColor(BUTTON_FILL_COLOR)
    love.graphics.rectangle("fill", 0, 0, self.size.x + BUTTON_PADDING * 2, self.size.y + BUTTON_PADDING * 2)
    love.graphics.setColor(BUTTON_OUTLINE_COLOR)
    love.graphics.rectangle("line", 0, 0, self.size.x + BUTTON_PADDING * 2, love.graphics.getFont():getHeight() + BUTTON_PADDING * 2)
    love.graphics.print(self.text, BUTTON_PADDING, BUTTON_PADDING);
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