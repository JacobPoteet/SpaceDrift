---@class World World generation and object management
local World = {}
World.__index = World

local constants = require("utils.constants")
local Vector2 = require("classes.Vector2")
local Planet = require("classes.Planet")

---Create a new World instance
---@return World
function World.new()
    local self = setmetatable({}, World)

    -- World properties
    self.size = constants.WORLD_SIZE
    self.planets = {}
    self.seed = constants.WORLD_SEED

    -- Generate the world
    self:generate()

    return self
end

---Generate the procedural world
function World:generate()
    -- Set the random seed for consistent generation
    love.math.setRandomSeed(self.seed)

    -- Clear existing planets
    self.planets = {}

    -- Generate planets
    local attempts = 0
    local maxAttempts = constants.PLANET_COUNT * 10

    while #self.planets < constants.PLANET_COUNT and attempts < maxAttempts do
        attempts = attempts + 1

        -- Generate random planet position
        local x = love.math.random(-self.size / 2, self.size / 2)
        local y = love.math.random(-self.size / 2, self.size / 2)

        -- Check if position is valid (not too close to other planets)
        if self:isValidPlanetPosition(x, y) then
            -- Generate random planet size
            local size = love.math.random(constants.MIN_PLANET_SIZE, constants.MAX_PLANET_SIZE)

            -- Select random color
            local color = constants.PLANET_COLORS[love.math.random(1, #constants.PLANET_COLORS)]

            -- Create and add the planet
            local planet = Planet.new(x, y, size, color)
            table.insert(self.planets, planet)
        end
    end

    -- If we couldn't generate enough planets, add some anyway
    while #self.planets < constants.PLANET_COUNT do
        local x = love.math.random(-self.size / 2, self.size / 2)
        local y = love.math.random(-self.size / 2, self.size / 2)
        local size = love.math.random(constants.MIN_PLANET_SIZE, constants.MAX_PLANET_SIZE)
        local color = constants.PLANET_COLORS[love.math.random(1, #constants.PLANET_COLORS)]

        local planet = Planet.new(x, y, size, color)
        table.insert(self.planets, planet)
    end

    -- Add a few planets closer to the center for immediate visibility
    for i = 1, 3 do
        local angle = (i - 1) * math.pi * 2 / 3
        local distance = 300 + i * 100
        local x = math.cos(angle) * distance
        local y = math.sin(angle) * distance
        local size = love.math.random(constants.MIN_PLANET_SIZE, constants.MAX_PLANET_SIZE)
        local color = constants.PLANET_COLORS[love.math.random(1, #constants.PLANET_COLORS)]

        local planet = Planet.new(x, y, size, color)
        table.insert(self.planets, planet)
    end

    print("Generated " .. #self.planets .. " planets")
end

---Check if a planet position is valid (not too close to existing planets)
---@param x number
---@param y number
---@return boolean
function World:isValidPlanetPosition(x, y)
    for _, planet in ipairs(self.planets) do
        local distance = Vector2.new(x, y):distance(planet:getPosition())
        if distance < constants.MIN_PLANET_DISTANCE then
            return false
        end
    end
    return true
end

---Update all world objects
---@param dt number Delta time
function World:update(dt)
    for _, planet in ipairs(self.planets) do
        planet:update(dt)
    end
end

---Draw all visible world objects
---@param camera Camera The camera to use for visibility checks
function World:draw(camera)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    -- Draw background stars
    self:drawStars(camera, screenWidth, screenHeight)

    -- Draw planets
    for _, planet in ipairs(self.planets) do
        local planetPos = planet:getPosition()

        -- Check if planet is visible on screen
        if camera:isVisible(planetPos.x, planetPos.y, screenWidth, screenHeight) then
            planet:draw()
        end
    end
end

---Draw background stars
---@param camera Camera The camera to use
---@param screenWidth number Screen width
---@param screenHeight number Screen height
function World:drawStars(camera, screenWidth, screenHeight)
    -- Set random seed for consistent star positions
    love.math.setRandomSeed(self.seed)

    -- Draw a field of stars
    love.graphics.setColor(1, 1, 1, 0.8)

    for i = 1, 200 do
        -- Generate star position
        local x = love.math.random(-self.size / 2, self.size / 2)
        local y = love.math.random(-self.size / 2, self.size / 2)

        -- Check if star is visible
        if camera:isVisible(x, y, screenWidth, screenHeight) then
            -- Convert to screen coordinates
            local screenX, screenY = camera:worldToScreen(x, y)

            -- Draw star (simple white dot)
            local brightness = love.math.random(0.3, 1.0)
            love.graphics.setColor(1, 1, 1, brightness)
            love.graphics.circle("fill", screenX, screenY, 1)
        end
    end

    -- Reset color
    love.graphics.setColor(1, 1, 1, 1)
end

---Get all planets in the world
---@return table
function World:getPlanets()
    return self.planets
end

---Get the world size
---@return number
function World:getSize()
    return self.size
end

---Regenerate the world with a new seed
---@param newSeed number New random seed
function World:regenerate(newSeed)
    self.seed = newSeed or constants.WORLD_SEED
    self:generate()
end

---Get the closest planet to a position
---@param x number
---@param y number
---@return Planet, number
function World:getClosestPlanet(x, y)
    local closestPlanet = nil
    local closestDistance = math.huge

    for _, planet in ipairs(self.planets) do
        local distance = Vector2.new(x, y):distance(planet:getPosition())
        if distance < closestDistance then
            closestDistance = distance
            closestPlanet = planet
        end
    end

    return closestPlanet, closestDistance
end

---Check if a position is within any planet's influence
---@param x number
---@param y number
---@return Planet, number
function World:getPlanetAtPosition(x, y)
    for _, planet in ipairs(self.planets) do
        if planet:containsPoint(x, y) then
            return planet, 0
        end
    end

    return nil, math.huge
end

return World
