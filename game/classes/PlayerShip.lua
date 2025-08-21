---@class PlayerShip Centered ship with movement feedback
local PlayerShip = {}
PlayerShip.__index = PlayerShip

local constants = require("utils.constants")
local Vector2 = require("classes.Vector2")

---Create a new PlayerShip instance
---@return PlayerShip
function PlayerShip.new()
    local self = setmetatable({}, PlayerShip)

    -- Ship properties
    self.position = Vector2.zero() -- Always centered on screen
    self.size = constants.SHIP_SIZE
    self.rotation = 0
    self.targetRotation = 0

    -- Movement feedback
    self.swayAmount = constants.SHIP_SWAY_AMOUNT
    self.swaySpeed = constants.SHIP_SWAY_SPEED
    self.swayOffset = Vector2.zero()
    self.swayTime = 0

    -- Engine effects
    self.engineGlow = 0
    self.engineGlowSpeed = 3

    return self
end

---Update the ship's swaying based on window movement
---@param dt number Delta time
---@param windowDelta Vector2 Window movement delta
function PlayerShip:update(dt, windowDelta)
    -- Update sway time
    self.swayTime = self.swayTime + dt * self.swaySpeed

    -- Calculate sway based on window movement
    local swayX = math.sin(self.swayTime) * self.swayAmount * 0.1
    local swayY = math.cos(self.swayTime * 0.7) * self.swayAmount * 0.1

    -- Add window movement feedback
    if windowDelta then
        local movementScale = 0.01
        swayX = swayX + windowDelta.x * movementScale
        swayY = swayY + windowDelta.y * movementScale
    end

    self.swayOffset:set(swayX, swayY)

    -- Update engine glow
    self.engineGlow = self.engineGlow + dt * self.engineGlowSpeed
    if self.engineGlow > math.pi * 2 then
        self.engineGlow = self.engineGlow - math.pi * 2
    end
end

---Draw the ship
function PlayerShip:draw()
    love.graphics.push()

    -- Apply sway offset
    love.graphics.translate(self.swayOffset.x, self.swayOffset.y)

    -- Draw engine glow
    self:drawEngineGlow()

    -- Draw main ship body
    self:drawShipBody()

    -- Draw ship details
    self:drawShipDetails()

    love.graphics.pop()
end

---Draw the ship's engine glow
function PlayerShip:drawEngineGlow()
    local glowIntensity = (math.sin(self.engineGlow) + 1) * 0.5
    love.graphics.setColor(1, 0.5, 0, glowIntensity * 0.8)

    -- Draw engine exhaust
    local exhaustLength = self.size * 0.8
    local exhaustWidth = self.size * 0.3

    love.graphics.polygon("fill",
        -self.size * 0.8, -exhaustWidth * 0.5,
        -self.size * 0.8 - exhaustLength, 0,
        -self.size * 0.8, exhaustWidth * 0.5
    )
end

---Draw the main ship body
function PlayerShip:drawShipBody()
    -- Main ship triangle
    love.graphics.setColor(0.8, 0.8, 0.9)
    love.graphics.polygon("fill",
        self.size * 0.8, 0,                    -- Nose
        -self.size * 0.6, -self.size * 0.5,    -- Left wing
        -self.size * 0.6, self.size * 0.5      -- Right wing
    )

    -- Ship outline
    love.graphics.setColor(0.6, 0.6, 0.7)
    love.graphics.setLineWidth(2)
    love.graphics.polygon("line",
        self.size * 0.8, 0,
        -self.size * 0.6, -self.size * 0.5,
        -self.size * 0.6, self.size * 0.5
    )
    love.graphics.setLineWidth(1)
end

---Draw ship details
function PlayerShip:drawShipDetails()
    -- Cockpit
    love.graphics.setColor(0.9, 0.9, 1.0)
    love.graphics.circle("fill", self.size * 0.2, 0, self.size * 0.2)

    -- Cockpit outline
    love.graphics.setColor(0.7, 0.7, 0.8)
    love.graphics.setLineWidth(1)
    love.graphics.circle("line", self.size * 0.2, 0, self.size * 0.2)

    -- Wing details
    love.graphics.setColor(0.7, 0.7, 0.8)
    love.graphics.setLineWidth(1)

    -- Left wing detail
    love.graphics.line(
        -self.size * 0.4, -self.size * 0.3,
        -self.size * 0.2, -self.size * 0.1
    )

    -- Right wing detail
    love.graphics.line(
        -self.size * 0.4, self.size * 0.3,
        -self.size * 0.2, self.size * 0.1
    )

    -- Nose detail
    love.graphics.setColor(0.6, 0.6, 0.7)
    love.graphics.circle("fill", self.size * 0.9, 0, self.size * 0.05)

    love.graphics.setLineWidth(1)
end

---Get the ship's position (always centered)
---@return Vector2
function PlayerShip:getPosition()
    return self.position:copy()
end

---Get the ship's size
---@return number
function PlayerShip:getSize()
    return self.size
end

---Get the ship's sway offset
---@return Vector2
function PlayerShip:getSwayOffset()
    return self.swayOffset:copy()
end

return PlayerShip
