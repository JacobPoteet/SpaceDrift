---@class Window Window management class for movement, resizing, and boundary detection
local Window = {}
Window.__index = Window

local constants = require("utils.constants")

---Create a new Window instance
---@return Window
function Window.new()
    local self = setmetatable({}, Window)

    -- Window state
    self.position = require("classes.Vector2").new(constants.WINDOW_START_X, constants.WINDOW_START_Y)
    self.size = require("classes.Vector2").new(constants.WINDOW_WIDTH, constants.WINDOW_HEIGHT)
    self.isDragging = false
    self.dragOffset = require("classes.Vector2").zero()
    self.isResizing = false
    self.resizeCorner = nil -- "nw", "ne", "sw", "se"

    -- Initialize window position
    self:setPosition(self.position.x, self.position.y)

    return self
end

---Set the window position
---@param x number
---@param y number
function Window:setPosition(x, y)
    -- Clamp to boundaries
    x = math.max(constants.MIN_WINDOW_X, math.min(constants.MAX_WINDOW_X, x))
    y = math.max(constants.MIN_WINDOW_Y, math.min(constants.MAX_WINDOW_Y, y))

    self.position:set(x, y)
    love.window.setPosition(x, y)
end

---Get the window position
---@return Vector2
function Window:getPosition()
    return self.position:copy()
end

---Get the window center position in world coordinates
---@return Vector2
function Window:getCenter()
    return require("classes.Vector2").new(
        self.position.x + self.size.x / 2,
        self.position.y + self.size.y / 2
    )
end

---Get the window size
---@return Vector2
function Window:getSize()
    return self.size:copy()
end

---Start dragging the window
---@param x number Mouse X position
---@param y number Mouse Y position
function Window:startDrag(x, y)
    if not self.isDragging then
        self.isDragging = true
        self.dragOffset:set(x - self.position.x, y - self.position.y)
    end
end

---Update dragging
---@param x number Mouse X position
---@param y number Mouse Y position
function Window:updateDrag(x, y)
    if self.isDragging then
        local newX = x - self.dragOffset.x
        local newY = y - self.dragOffset.y
        self:setPosition(newX, newY)
    end
end

---Stop dragging
function Window:stopDrag()
    self.isDragging = false
end

---Start resizing the window
---@param x number Mouse X position
---@param y number Mouse Y position
function Window:startResize(x, y)
    if not self.isResizing then
        self.isResizing = true

        -- Determine which corner is being dragged
        local cornerX = x < self.size.x / 2 and "w" or "e"
        local cornerY = y < self.size.y / 2 and "n" or "s"
        self.resizeCorner = cornerY .. cornerX
    end
end

---Update resizing
---@param x number Mouse X position
---@param y number Mouse Y position
function Window:updateResize(x, y)
    if self.isResizing then
        local newWidth = self.size.x
        local newHeight = self.size.y
        local newX = self.position.x
        local newY = self.position.y

        if self.resizeCorner:find("e") then
            newWidth = math.max(300, x)
        elseif self.resizeCorner:find("w") then
            local deltaX = self.size.x - x
            newWidth = math.max(300, deltaX)
            newX = self.position.x + (self.size.x - newWidth)
        end

        if self.resizeCorner:find("s") then
            newHeight = math.max(300, y)
        elseif self.resizeCorner:find("n") then
            local deltaY = self.size.y - y
            newHeight = math.max(300, deltaY)
            newY = self.position.y + (self.size.y - newHeight)
        end

        -- Apply new size and position
        self.size:set(newWidth, newHeight)
        self:setPosition(newX, newY)
    end
end

---Stop resizing
function Window:stopResize()
    self.isResizing = false
    self.resizeCorner = nil
end

---Check if a point is within the window bounds
---@param x number
---@param y number
---@return boolean
function Window:containsPoint(x, y)
    return x >= self.position.x and x <= self.position.x + self.size.x and
           y >= self.position.y and y <= self.position.y + self.size.y
end

---Check if a point is near the window edge for resizing
---@param x number
---@param y number
---@param threshold number Edge detection threshold
---@return boolean, string
function Window:isNearEdge(x, y, threshold)
    threshold = threshold or 10

    local localX = x - self.position.x
    local localY = y - self.position.y

    local nearLeft = localX <= threshold
    local nearRight = localX >= self.size.x - threshold
    local nearTop = localY <= threshold
    local nearBottom = localY >= self.size.y - threshold

    if nearLeft and nearTop then return true, "nw"
    elseif nearRight and nearTop then return true, "ne"
    elseif nearLeft and nearBottom then return true, "sw"
    elseif nearRight and nearBottom then return true, "se"
    elseif nearLeft then return true, "w"
    elseif nearRight then return true, "e"
    elseif nearTop then return true, "n"
    elseif nearBottom then return true, "s"
    end

    return false, nil
end

---Update the window system
---@param dt number Delta time
function Window:update(dt)
    -- Window updates are handled in mouse events
end

---Draw window debug info (optional)
function Window:draw()
    -- Debug drawing can be added here if needed
end

return Window
