---@class Planet Procedural planet generation and rendering
local Planet = {}
Planet.__index = Planet

local constants = require("utils.constants")
local Vector2 = require("classes.Vector2")

---Create a new Planet instance
---@param x number World X position
---@param y number World Y position
---@param size number Planet size
---@param color table Planet color {r, g, b}
---@return Planet
function Planet.new(x, y, size, color)
    local self = setmetatable({}, Planet)

    -- Planet properties
    self.position = Vector2.new(x, y)
    self.size = size or love.math.random(constants.MIN_PLANET_SIZE, constants.MAX_PLANET_SIZE)
    self.color = color or constants.PLANET_COLORS[love.math.random(1, #constants.PLANET_COLORS)]

    -- Visual properties
    self.rotation = love.math.random() * math.pi * 2
    self.rotationSpeed = (love.math.random() - 0.5) * 0.5
    self.atmosphereSize = self.size * 1.2
    self.ringCount = love.math.random(0, 3)
    self.hasRings = self.ringCount > 0

    -- Generate ring properties if planet has rings
    if self.hasRings then
        self.ringInnerRadius = self.size * 1.5
        self.ringOuterRadius = self.size * 2.5
        self.ringColor = {self.color[1] * 0.7, self.color[2] * 0.7, self.color[3] * 0.7}
    end

    return self
end

---Update the planet
---@param dt number Delta time
function Planet:update(dt)
    -- Rotate the planet
    self.rotation = self.rotation + self.rotationSpeed * dt
end

---Draw the planet
function Planet:draw()
    love.graphics.push()

    -- Move to planet position
    love.graphics.translate(self.position.x, self.position.y)
    love.graphics.rotate(self.rotation)

    -- Draw atmosphere (outer glow)
    love.graphics.setColor(self.color[1] * 0.3, self.color[2] * 0.3, self.color[3] * 0.3, 0.5)
    love.graphics.circle("fill", 0, 0, self.atmosphereSize)

    -- Draw main planet body
    love.graphics.setColor(self.color[1], self.color[2], self.color[3])
    love.graphics.circle("fill", 0, 0, self.size)

    -- Draw planet surface details (simple geometric patterns)
    self:drawSurfaceDetails()

    -- Draw rings if planet has them
    if self.hasRings then
        self:drawRings()
    end

    love.graphics.pop()
end

---Draw surface details on the planet
function Planet:drawSurfaceDetails()
    -- Draw some simple geometric patterns on the surface
    love.graphics.setColor(self.color[1] * 0.8, self.color[2] * 0.8, self.color[3] * 0.8)

    -- Draw a few craters or surface features
    for i = 1, 3 do
        local angle = (i * math.pi * 2 / 3) + self.rotation
        local distance = self.size * 0.6
        local craterSize = self.size * 0.15

        local x = math.cos(angle) * distance
        local y = math.sin(angle) * distance

        love.graphics.circle("fill", x, y, craterSize)
    end

    -- Draw a simple equator line
    love.graphics.setColor(self.color[1] * 0.6, self.color[2] * 0.6, self.color[3] * 0.6)
    love.graphics.setLineWidth(2)
    love.graphics.line(-self.size, 0, self.size, 0)
    love.graphics.setLineWidth(1)
end

---Draw planet rings
function Planet:drawRings()
    if not self.hasRings then return end

    love.graphics.setColor(self.ringColor[1], self.ringColor[2], self.ringColor[3], 0.7)

    -- Draw multiple ring layers
    for i = 1, self.ringCount do
        local innerRadius = self.ringInnerRadius + (i - 1) * 10
        local outerRadius = innerRadius + 8

        -- Create ring shape using multiple line segments
        local segments = 32
        for j = 1, segments do
            local angle1 = (j - 1) * math.pi * 2 / segments
            local angle2 = j * math.pi * 2 / segments

            local x1 = math.cos(angle1) * innerRadius
            local y1 = math.sin(angle1) * innerRadius
            local x2 = math.cos(angle2) * innerRadius
            local y2 = math.sin(angle2) * innerRadius

            local x3 = math.cos(angle2) * outerRadius
            local y3 = math.sin(angle2) * outerRadius
            local x4 = math.cos(angle1) * outerRadius
            local y4 = math.sin(angle1) * outerRadius

            love.graphics.polygon("fill", x1, y1, x2, y2, x3, y3, x4, y4)
        end
    end
end

---Get the planet's bounding box for collision detection
---@return number, number, number, number
function Planet:getBounds()
    local maxRadius = self.hasRings and self.ringOuterRadius or self.atmosphereSize
    return self.position.x - maxRadius, self.position.y - maxRadius,
           self.position.x + maxRadius, self.position.y + maxRadius
end

---Check if a point is within the planet's influence
---@param x number
---@param y number
---@return boolean
function Planet:containsPoint(x, y)
    local distance = self.position:distance(Vector2.new(x, y))
    return distance <= self.size
end

---Get the planet's position
---@return Vector2
function Planet:getPosition()
    return self.position:copy()
end

---Get the planet's size
---@return number
function Planet:getSize()
    return self.size
end

return Planet
