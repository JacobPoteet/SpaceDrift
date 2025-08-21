---@class Vector2 2D vector class for positions and movement
local Vector2 = {}
Vector2.__index = Vector2

---Create a new Vector2 instance
---@param x number X coordinate
---@param y number Y coordinate
---@return Vector2
function Vector2.new(x, y)
    local self = setmetatable({}, Vector2)
    self.x = x or 0
    self.y = y or 0
    return self
end

---Create a zero vector
---@return Vector2
function Vector2.zero()
    return Vector2.new(0, 0)
end

---Add another vector to this one
---@param other Vector2
---@return Vector2
function Vector2:add(other)
    return Vector2.new(self.x + other.x, self.y + other.y)
end

---Subtract another vector from this one
---@param other Vector2
---@return Vector2
function Vector2:sub(other)
    return Vector2.new(self.x - other.x, self.y - other.y)
end

---Multiply this vector by a scalar
---@param scalar number
---@return Vector2
function Vector2:mul(scalar)
    return Vector2.new(self.x * scalar, self.y * scalar)
end

---Divide this vector by a scalar
---@param scalar number
---@return Vector2
function Vector2:div(scalar)
    return Vector2.new(self.x / scalar, self.y / scalar)
end

---Get the magnitude (length) of this vector
---@return number
function Vector2:length()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

---Normalize this vector to unit length
---@return Vector2
function Vector2:normalize()
    local len = self:length()
    if len == 0 then
        return Vector2.zero()
    end
    return self:div(len)
end

---Get the distance between this vector and another
---@param other Vector2
---@return number
function Vector2:distance(other)
    return self:sub(other):length()
end

---Lerp between this vector and another
---@param other Vector2
---@param t number Interpolation factor (0-1)
---@return Vector2
function Vector2:lerp(other, t)
    return Vector2.new(
        self.x + (other.x - self.x) * t,
        self.y + (other.y - self.y) * t
    )
end

---Copy this vector
---@return Vector2
function Vector2:copy()
    return Vector2.new(self.x, self.y)
end

---Set the components of this vector
---@param x number
---@param y number
function Vector2:set(x, y)
    self.x = x
    self.y = y
end

---Check if this vector equals another
---@param other Vector2
---@return boolean
function Vector2:equals(other)
    return self.x == other.x and self.y == other.y
end

return Vector2
