---@class Camera Camera positioning and viewport management
local Camera = {}
Camera.__index = Camera

local constants = require("utils.constants")

---Create a new Camera instance
---@return Camera
function Camera.new()
    local self = setmetatable({}, Camera)

    -- Camera state
    self.position = require("classes.Vector2").zero()
    self.targetPosition = require("classes.Vector2").zero()
    self.zoom = 1.0
    self.targetZoom = 1.0

    return self
end

---Update camera position based on window movement
---@param windowPosition Vector2 Window position
---@param windowSize Vector2 Window size
function Camera:updateFromWindow(windowPosition, windowSize)
    -- Calculate the center of the window in world coordinates
    local windowCenter = require("classes.Vector2").new(
        windowPosition.x + windowSize.x / 2,
        windowPosition.y + windowSize.y / 2
    )

    -- Set target position with 1:1 movement scale
    self.targetPosition:set(
        -windowCenter.x * constants.CAMERA_MOVEMENT_SCALE,
        -windowCenter.y * constants.CAMERA_MOVEMENT_SCALE
    )

    -- Apply movement immediately (no smoothing)
    self.position:set(self.targetPosition.x, self.targetPosition.y)
end

---Get the camera position
---@return Vector2
function Camera:getPosition()
    return self.position:copy()
end

---Set the camera position
---@param x number
---@param y number
function Camera:setPosition(x, y)
    self.position:set(x, y)
    self.targetPosition:set(x, y)
end

---Get the camera zoom
---@return number
function Camera:getZoom()
    return self.zoom
end

---Set the camera zoom
---@param zoom number
function Camera:setZoom(zoom)
    self.zoom = zoom
    self.targetZoom = zoom
end

---Apply camera transformation to graphics
function Camera:apply()
    love.graphics.push()
    love.graphics.translate(self.position.x, self.position.y)
    love.graphics.scale(self.zoom, self.zoom)
end

---Restore graphics transformation
function Camera:restore()
    love.graphics.pop()
end

---Convert screen coordinates to world coordinates
---@param screenX number
---@param screenY number
---@return number, number
function Camera:screenToWorld(screenX, screenY)
    local worldX = (screenX - self.position.x) / self.zoom
    local worldY = (screenY - self.position.y) / self.zoom
    return worldX, worldY
end

---Convert world coordinates to screen coordinates
---@param worldX number
---@param worldY number
---@return number, number
function Camera:worldToScreen(worldX, worldY)
    local screenX = worldX * self.zoom + self.position.x
    local screenY = worldY * self.zoom + self.position.y
    return screenX, screenY
end

---Check if a world position is visible on screen
---@param worldX number
---@param worldY number
---@param screenWidth number
---@param screenHeight number
---@return boolean
function Camera:isVisible(worldX, worldY, screenWidth, screenHeight)
    local screenX, screenY = self:worldToScreen(worldX, worldY)
    return screenX >= -100 and screenX <= screenWidth + 100 and
           screenY >= -100 and screenY <= screenHeight + 100
end

---Update the camera
---@param dt number Delta time
function Camera:update(dt)
    -- Camera updates are handled in updateFromWindow
end

return Camera
