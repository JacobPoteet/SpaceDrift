https = nil
local overlayStats = require("lib.overlayStats")
local runtimeLoader = require("runtime.loader")
local Game = require("classes.Game")

-- Global game instance
local game = nil

function love.load()

  -- Initialize the space exploration game
  game = Game.new()
  game:load()

  overlayStats.load() -- Should always be called last
end

function love.draw()
  -- Draw the game
  if game then
    game:draw()
  end

  overlayStats.draw() -- Should always be called last
end

function love.update(dt)
  -- Update the game
  if game then
    game:update(dt)
  end

  overlayStats.update(dt) -- Should always be called last
end

function love.keypressed(key)
  if key == "escape" and love.system.getOS() ~= "Web" then
    love.event.quit()
  else
    -- Handle game key events
    if game then
      game:keypressed(key)
    end

    overlayStats.handleKeyboard(key) -- Should always be called last
  end
end

function love.mousepressed(x, y, button, isTouch)
  if game then
    game:mousepressed(x, y, button, isTouch)
  end
end

function love.mousereleased(x, y, button, isTouch)
  if game then
    game:mousereleased(x, y, button, isTouch)
  end
end

function love.mousemoved(x, y, dx, dy, isTouch)
  if game then
    game:mousemoved(x, y, dx, dy, isTouch)
  end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
  overlayStats.handleTouch(id, x, y, dx, dy, pressure) -- Should always be called last
end

function love.resize(width, height)
  if game then
    game:resize(width, height)
  end
end
