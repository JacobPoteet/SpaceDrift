---@class Game Main game loop and state management
local Game = {}
Game.__index = Game

local constants = require("utils.constants")
local Vector2 = require("classes.Vector2")
local Window = require("classes.Window")
local Camera = require("classes.Camera")
local PlayerShip = require("classes.PlayerShip")
local World = require("classes.World")

---Create a new Game instance
---@return Game
function Game.new()
    local self = setmetatable({}, Game)

    -- Game state
    self.state = "playing" -- "playing", "paused", "menu"
    self.isRunning = true

    -- Game systems
    self.window = Window.new()
    self.camera = Camera.new()
    self.playerShip = PlayerShip.new()
    self.world = World.new()

    -- Window movement tracking
    self.lastWindowPosition = self.window:getPosition():copy()
    self.windowDelta = Vector2.zero()

    -- Performance tracking
    self.frameCount = 0
    self.lastFPS = 0
    self.lastFPSTime = 0

    return self
end

---Initialize the game
function Game:load()
    -- Set window properties
    love.window.setMode(constants.WINDOW_WIDTH, constants.WINDOW_HEIGHT, {
        resizable = true,
        borderless = false,
        fullscreen = false,
        vsync = true
    })

    -- Set initial window position
    self.window:setPosition(constants.WINDOW_START_X, constants.WINDOW_START_Y)

    -- Initialize camera
    self.camera:updateFromWindow(self.window:getPosition(), self.window:getSize())

    print("Space Exploration Game initialized")
    print("Window size: " .. constants.WINDOW_WIDTH .. "x" .. constants.WINDOW_HEIGHT)
    print("Window position: (" .. constants.WINDOW_START_X .. ", " .. constants.WINDOW_START_Y .. ")")
    print("World size: " .. self.world:getSize())
    print("Planets generated: " .. #self.world:getPlanets())
    print("Camera position: (" .. self.camera:getPosition().x .. ", " .. self.camera:getPosition().y .. ")")
    print("Press SPACE to pause and see debug grid")
    print("Press R to generate new world")
end

---Update the game
---@param dt number Delta time
function Game:update(dt)
    if not self.isRunning or self.state ~= "playing" then
        return
    end

    -- Track window movement
    local currentWindowPos = self.window:getPosition()
    self.windowDelta:set(
        currentWindowPos.x - self.lastWindowPosition.x,
        currentWindowPos.y - self.lastWindowPosition.y
    )
    self.lastWindowPosition:set(currentWindowPos.x, currentWindowPos.y)

    -- Update camera based on window position
    self.camera:updateFromWindow(currentWindowPos, self.window:getSize())

    -- Update game systems
    self.world:update(dt)
    self.playerShip:update(dt, self.windowDelta)

    -- Update performance tracking
    self.frameCount = self.frameCount + 1
    if love.timer.getTime() - self.lastFPSTime >= 1.0 then
        self.lastFPS = self.frameCount
        self.frameCount = 0
        self.lastFPSTime = love.timer.getTime()
    end
end

---Draw the game
function Game:draw()
    -- Clear screen with space background
    love.graphics.setColor(0.05, 0.05, 0.1)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    -- Apply camera transformation
    self.camera:apply()

    -- Draw debug grid (optional - helps visualize world coordinates)
    self:drawDebugGrid()

    -- Draw world (planets and stars)
    self.world:draw(self.camera)

    -- Restore camera transformation
    self.camera:restore()

    -- Draw player ship (always centered)
    local screenCenterX = love.graphics.getWidth() / 2
    local screenCenterY = love.graphics.getHeight() / 2

    love.graphics.push()
    love.graphics.translate(screenCenterX, screenCenterY)
    self.playerShip:draw()
    love.graphics.pop()

    -- Draw UI elements
    self:drawUI()
end

---Draw debug grid to visualize world coordinates
function Game:drawDebugGrid()
    if self.state == "paused" then
        love.graphics.setColor(0.3, 0.3, 0.3, 0.5)
        love.graphics.setLineWidth(1)

        -- Draw grid lines every 500 pixels
        local gridSize = 500
        local startX = math.floor(self.camera.position.x / gridSize) * gridSize
        local startY = math.floor(self.camera.position.y / gridSize) * gridSize
        local endX = startX + love.graphics.getWidth() + gridSize
        local endY = startY + love.graphics.getHeight() + gridSize

        -- Vertical lines
        for x = startX, endX, gridSize do
            love.graphics.line(x, startY, x, endY)
        end

        -- Horizontal lines
        for y = startY, endY, gridSize do
            love.graphics.line(startX, y, endX, y)
        end

        -- Draw origin marker
        love.graphics.setColor(1, 0, 0, 0.8)
        love.graphics.circle("fill", 0, 0, 10)
        love.graphics.setColor(1, 1, 1, 0.8)
        love.graphics.print("ORIGIN", 15, -5)

        love.graphics.setLineWidth(1)
    end
end

---Draw UI elements
function Game:drawUI()
    -- Draw FPS counter
    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.print("FPS: " .. self.lastFPS, 10, 10)

    -- Draw window position info
    local windowPos = self.window:getPosition()
    love.graphics.print(string.format("Window: (%d, %d)", windowPos.x, windowPos.y), 10, 30)

    -- Draw window size info
    local windowSize = self.window:getSize()
    love.graphics.print(string.format("Size: %dx%d", windowSize.x, windowSize.y), 10, 50)

    -- Draw world info
    local worldCenter = self.camera:getPosition()
    love.graphics.print(string.format("Camera: (%.0f, %.0f)", worldCenter.x, worldCenter.y), 10, 70)

    -- Draw planet count
    love.graphics.print("Planets: " .. #self.world:getPlanets(), 10, 90)

    -- Draw instructions
    love.graphics.setColor(1, 1, 1, 0.6)
    love.graphics.print("Drag window to explore space", 10, love.graphics.getHeight() - 60)
    love.graphics.print("Resize window edges to change view", 10, love.graphics.getHeight() - 40)
    love.graphics.print("R: New world, Space: Pause, Esc: Quit", 10, love.graphics.getHeight() - 20)

    -- Draw debug info
    if self.state == "paused" then
        love.graphics.setColor(1, 0, 0, 0.8)
        love.graphics.print("PAUSED", love.graphics.getWidth() / 2 - 30, 10)
    end
end

---Handle mouse press events
---@param x number
---@param y number
---@param button number
---@param isTouch boolean
function Game:mousepressed(x, y, button, isTouch)
    if button == 1 then -- Left mouse button
        -- Check if clicking near window edge for resizing
        local nearEdge, edgeType = self.window:isNearEdge(x, y)
        if nearEdge then
            self.window:startResize(x, y)
        else
            -- Start dragging the window from anywhere else
            self.window:startDrag(x, y)
        end
    end
end

---Handle mouse release events
---@param x number
---@param y number
---@param button number
---@param isTouch boolean
function Game:mousereleased(x, y, button, isTouch)
    if button == 1 then -- Left mouse button
        if self.window.isResizing then
            self.window:stopResize()
        elseif self.window.isDragging then
            self.window:stopDrag()
        end
    end
end

---Handle mouse movement events
---@param x number
---@param y number
---@param dx number
---@param dy number
---@param isTouch boolean
function Game:mousemoved(x, y, dx, dy, isTouch)
    if self.window.isResizing then
        self.window:updateResize(x, y)
    elseif self.window.isDragging then
        self.window:updateDrag(x, y)
    end
end

---Handle key press events
---@param key string
---@param scancode string
---@param isrepeat boolean
function Game:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    elseif key == "r" then
        -- Regenerate world with new seed
        self.world:regenerate(love.math.random(1, 1000000))
        print("World regenerated with new seed")
    elseif key == "space" then
        -- Toggle pause
        if self.state == "playing" then
            self.state = "paused"
        else
            self.state = "playing"
        end
    end
end

---Handle window resize events
---@param width number
---@param height number
function Game:resize(width, height)
    -- Update window size tracking
    self.window.size:set(width, height)

    -- Update camera
    self.camera:updateFromWindow(self.window:getPosition(), self.window:getSize())

    print("Window resized to: " .. width .. "x" .. height)
end

---Get the game state
---@return string
function Game:getState()
    return self.state
end

---Set the game state
---@param state string
function Game:setState(state)
    self.state = state
end

---Check if the game is running
---@return boolean
function Game:isGameRunning()
    return self.isRunning
end

---Stop the game
function Game:stop()
    self.isRunning = false
end

return Game
