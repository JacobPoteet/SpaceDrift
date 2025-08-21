-- Test script to verify game classes can be loaded
print("Testing Space Exploration Game classes...")

-- Test Vector2 class
print("Testing Vector2...")
local Vector2 = require("classes.Vector2")
local v1 = Vector2.new(10, 20)
local v2 = Vector2.new(5, 15)
local v3 = v1:add(v2)
print("Vector2 test: " .. v3.x .. ", " .. v3.y)

-- Test constants
print("Testing constants...")
local constants = require("utils.constants")
print("Window size: " .. constants.WINDOW_WIDTH .. "x" .. constants.WINDOW_HEIGHT)
print("World size: " .. constants.WORLD_SIZE)

-- Test Window class
print("Testing Window...")
local Window = require("classes.Window")
local window = Window.new()
print("Window created at: " .. window:getPosition().x .. ", " .. window:getPosition().y)

-- Test Camera class
print("Testing Camera...")
local Camera = require("classes.Camera")
local camera = Camera.new()
print("Camera created")

-- Test Planet class
print("Testing Planet...")
local Planet = require("classes.Planet")
local planet = Planet.new(100, 200, 50)
print("Planet created at: " .. planet:getPosition().x .. ", " .. planet:getPosition().y)

-- Test PlayerShip class
print("Testing PlayerShip...")
local PlayerShip = require("classes.PlayerShip")
local ship = PlayerShip.new()
print("PlayerShip created")

-- Test World class
print("Testing World...")
local World = require("classes.World")
local world = World.new()
print("World created with " .. #world:getPlanets() .. " planets")

-- Test Game class
print("Testing Game...")
local Game = require("classes.Game")
local game = Game.new()
print("Game created successfully!")

print("All classes loaded successfully!")
print("Game is ready to run!")
