Card = {width = 64, height = 128}
Card.mt = {__index=Card}

SUITS = {
    HEARTS = 0,
    SPADES = 1,
    DIAMONDS = 2,
    CLUBS = 3,
}

function Card.setupSprites()
end

function Card:new(position, suit, rank)
    local o = {}
    setmetatable(o, Card.mt)
    o.position = position
    o.suit = suit
    o.rank = rank
    return o
end

function Card:update(dt)
end

function Card:draw(dt)
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.width, self.height, 6, 6)
end

function Card:canStackOnTopOf(other)
    return (self.suit % 2 ~= other.suit % 2) and other.rank - self.rank == 1
end
