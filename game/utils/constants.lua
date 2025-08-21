-- Game Constants
local constants = {}

-- Monitor and Window Settings
constants.MONITOR_WIDTH = 2560
constants.MONITOR_HEIGHT = 1440
constants.WINDOW_WIDTH = 500
constants.WINDOW_HEIGHT = 500
constants.WINDOW_START_X = (constants.MONITOR_WIDTH - constants.WINDOW_WIDTH) / 2
constants.WINDOW_START_Y = (constants.MONITOR_HEIGHT - constants.WINDOW_HEIGHT) / 2

-- Movement Boundaries (1440p monitor dimensions)
constants.MIN_WINDOW_X = 0
constants.MAX_WINDOW_X = constants.MONITOR_WIDTH - constants.WINDOW_WIDTH
constants.MIN_WINDOW_Y = 0
constants.MAX_WINDOW_Y = constants.MONITOR_HEIGHT - constants.WINDOW_HEIGHT

-- World Generation
constants.WORLD_SEED = 42
constants.WORLD_SIZE = 5000  -- Reduced from 10000 for better visibility
constants.PLANET_COUNT = 20   -- Increased from 15 for more content
constants.MIN_PLANET_DISTANCE = 400  -- Reduced from 800 for closer planets

-- Planet Constants
constants.MIN_PLANET_SIZE = 40   -- Increased from 30 for better visibility
constants.MAX_PLANET_SIZE = 150  -- Increased from 120 for more variety
constants.PLANET_COLORS = {
    {0.8, 0.6, 0.4}, -- Brown
    {0.4, 0.6, 0.8}, -- Blue
    {0.8, 0.4, 0.6}, -- Pink
    {0.6, 0.8, 0.4}, -- Green
    {0.8, 0.8, 0.4}, -- Yellow
    {0.6, 0.4, 0.8}, -- Purple
    {0.8, 0.4, 0.4}, -- Red
    {0.4, 0.8, 0.8}  -- Cyan
}

-- Player Ship Constants
constants.SHIP_SIZE = 20
constants.SHIP_SWAY_AMOUNT = 3
constants.SHIP_SWAY_SPEED = 2

-- Camera Constants
constants.CAMERA_MOVEMENT_SCALE = 1.0 -- 1:1 movement with window

return constants
