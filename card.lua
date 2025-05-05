---@class Card
---@field suit Suit
---@field rank integer
---@field magic integer
Card = {width = 64, height = 96}
Card.mt = {__index=Card}

function Card.setupSprites()
    Card.sprites = {
        [SUITS.HEARTS] = love.graphics.newImage("sprites/heart.png"),
        [SUITS.SPADES] = love.graphics.newImage("sprites/spade.png"),
        [SUITS.DIAMONDS] = love.graphics.newImage("sprites/diamond.png"),
        [SUITS.CLUBS] = love.graphics.newImage("sprites/club.png"),
    }

    Card.font = love.graphics.newFont(18);
end

function Card:new(suit, rank)
    local o = {}
    setmetatable(o, Card.mt)
    o.suit = suit
    o.rank = rank
    o.magic = MAGIC_CARD
    return o
end

function Card:update(dt)
end

---Draw a card at a position
---@param position Vector
---@param dt number
---@param faceUp boolean
---@param shadowOffset number? Y-offset of the shadow. Used to render held cards with more shadow
function Card:draw(position, dt, faceUp, shadowOffset)
    love.graphics.setColor(CARD_SHADOW)
    love.graphics.rectangle("fill", position.x, position.y + (shadowOffset or 4), self.width, self.height, 6, 6)

    if faceUp then
        love.graphics.setColor(CARD_FACEUP_BG)
        love.graphics.rectangle("fill", position.x, position.y, self.width, self.height, 6, 6)
            
        love.graphics.setColor(COLORS[self.suit]);

        love.graphics.push();
        love.graphics.translate(position.x + self.width / 2, position.y + self.height / 2);
        for _, inner_position in ipairs(PATTERNS[self.rank]) do
            love.graphics.draw(self.sprites[self.suit], inner_position.x, inner_position.y);
        end
    
        love.graphics.setFont(self.font);
        love.graphics.printf(RANK_NAMES[self.rank], -28, -44, 100, "left");
        love.graphics.printf(RANK_NAMES[self.rank], -72, 24, 100, "right");
    
        love.graphics.pop();
    else
        love.graphics.setColor(CARD_FACEDOWN_BG)
        love.graphics.rectangle("fill", position.x, position.y, self.width, self.height, 6, 6)
    end

    love.graphics.setColor(CARD_BORDER)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", position.x, position.y, self.width, self.height, 6, 6)

end

function Card:drawGrabbed(dt, position)
    self:draw(position, dt, true, 4)
end

function Card:canStackOnTopOf(other)
    return (self.suit % 2 ~= other.suit % 2) and other.rank - self.rank == 1
end
