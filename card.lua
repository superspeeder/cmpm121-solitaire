Card = {width = 64, height = 96}
Card.mt = {__index=Card}

SUITS = {
    HEARTS = 1,
    SPADES = 2,
    DIAMONDS = 3,
    CLUBS = 4,
}

PATTERNS = {
    [1] = { {x=-4,y=-4} },
    [2] = { {x=8, y=-20}, {x=-16, y=14} },
    [3] = { {x=-4,y=-4}, {x=8, y=-20}, {x=-16, y=14} },
    [4] = { {x=-16,y=-20}, {x=8, y=-20}, {x=8,y=14}, {x=-16, y=14} },
    [5] = { {x=-4,y=-4}, {x=-16,y=-20}, {x=8, y=-20}, {x=8,y=14}, {x=-16, y=14} },
    [6] = { {x=-16,y=-4}, {x=8,y=-4}, {x=-16,y=-20}, {x=8, y=-20}, {x=8,y=14}, {x=-16, y=14} },
    [7] = { {x=-4,y=-4}, {x=-16,y=-4}, {x=8,y=-4}, {x=-16,y=-20}, {x=8, y=-20}, {x=8,y=14}, {x=-16, y=14} },
    [8] = { {x=-4,y=-12}, {x=-4,y=8}, {x=-16,y=-4}, {x=8,y=-4}, {x=-16,y=-20}, {x=8, y=-20}, {x=8,y=14}, {x=-16, y=14} },
    [9] = { {x=-4,y=-16}, {x=-4,y=8}, {x=-4,y=-4}, {x=-16,y=-4}, {x=8,y=-4}, {x=-16,y=-20}, {x=8, y=-20}, {x=8,y=14}, {x=-16, y=14} },
    [10] = { {x=-4,y=-24}, {x=-4,y=18}, {x=-4,y=-11}, {x=-4,y=3}, {x=-16,y=-4}, {x=8,y=-4}, {x=-16,y=-20}, {x=8, y=-20}, {x=8,y=14}, {x=-16, y=14} },
    [11] = { {x=-16,y=-24}, {x=-16,y=18}, {x=-16,y=-11}, {x=-16,y=3}, {x=8,y=-24}, {x=8,y=18}, {x=8,y=-11}, {x=8,y=3}, {x=-4,y=-4}, {x=-4,y=-20}, {x=-4, y=14} },
    [12] = { {x=-16,y=-24}, {x=-16,y=18}, {x=-16,y=-11}, {x=-16,y=3}, {x=-4,y=-24}, {x=-4,y=18}, {x=-4,y=-11}, {x=-4,y=3}, {x=8,y=-24}, {x=8,y=18}, {x=8,y=-11}, {x=8,y=3} },
    [13] = { {x=-16,y=-24}, {x=-16,y=18}, {x=-16,y=-11}, {x=-16,y=3}, {x=8,y=-24}, {x=8,y=18}, {x=8,y=-11}, {x=8,y=3}, {x=-4,y=-4}, {x=-4,y=-16}, {x=-4, y=10}, {x=-4, y=22}, {x=-4, y=-28} },
}

COLORS = {
    [SUITS.HEARTS] = {1,0,0,1},
    [SUITS.DIAMONDS] = {1,0,0,1},
    [SUITS.SPADES] = {0,0,0,1},
    [SUITS.CLUBS] = {0,0,0,1},
}

RANK_NAMES = {
    "A","2","3","4","5","6","7","8","9","10","J","Q","K"
}

function Card.setupSprites()
    Card.sprites = {
        [SUITS.HEARTS] = love.graphics.newImage("sprites/heart.png"),
        [SUITS.SPADES] = love.graphics.newImage("sprites/spade.png"),
        [SUITS.DIAMONDS] = love.graphics.newImage("sprites/diamond.png"),
        [SUITS.CLUBS] = love.graphics.newImage("sprites/club.png"),
    }

    Card.font = love.graphics.newFont(18);
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

    love.graphics.push();
    love.graphics.translate(self.position.x + self.width / 2, self.position.y + self.height / 2);
    for _, position in ipairs(PATTERNS[self.rank]) do
        love.graphics.draw(self.sprites[self.suit], position.x, position.y);
    end

    love.graphics.setFont(self.font);
    love.graphics.setColor(COLORS[self.suit]);
    love.graphics.printf(RANK_NAMES[self.rank], -28, -44, 100, "left");
    love.graphics.printf(RANK_NAMES[self.rank], -72, 24, 100, "right");

    love.graphics.pop();
end

function Card:canStackOnTopOf(other)
    return (self.suit % 2 ~= other.suit % 2) and other.rank - self.rank == 1
end
