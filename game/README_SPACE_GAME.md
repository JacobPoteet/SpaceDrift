# Space Exploration Game

A Love2D game where you explore space by moving and resizing the game window. The camera moves 1:1 with window movement, creating an immersive space exploration experience.

## Features

- **Window-Based Movement**: Drag the window to explore different areas of space
- **Window Resizing**: Resize the window edges to change your view
- **Procedural World**: 15 procedurally generated planets with unique colors and features
- **Player Ship**: Centered triangular ship with subtle swaying animation
- **1:1 Camera Movement**: Camera follows window movement exactly for precise control
- **Low-Poly Graphics**: Simple geometric shapes for optimal performance
- **Boundary System**: Movement limited to 1440p monitor dimensions

## Controls

- **Mouse Drag**: Move the window to explore space
- **Window Edge Drag**: Resize the window to change view
- **R Key**: Regenerate the world with a new random seed
- **Space Bar**: Toggle pause
- **Escape**: Quit the game

## Game Elements

### Player Ship
- Always centered on screen
- Subtle swaying animation that responds to window movement
- Triangular design with engine glow effects

### Planets
- Varying sizes (30-120 pixels)
- 8 different color schemes
- Some planets have rings
- Surface details like craters and equator lines
- Consistent generation using fixed seed

### World
- 10,000 x 10,000 pixel world size
- 200 background stars
- Procedural generation ensures planets don't overlap

## Technical Details

### Architecture
- **Vector2**: 2D math utilities for positions and movement
- **Window**: Window movement, resizing, and boundary detection
- **Camera**: Camera positioning and viewport management
- **PlayerShip**: Centered ship with movement feedback
- **Planet**: Procedural planet generation and rendering
- **World**: World generation and object management
- **Game**: Main game loop and state management

### Performance
- Low-poly rendering using simple shapes
- Visibility culling for off-screen objects
- Efficient coordinate transformations
- Minimal texture usage

### Window System
- Starts at 500x500 pixels
- Centered on 1440p monitor (2560x1440)
- Movement boundaries prevent window from going off-screen
- Smooth dragging and resizing

## File Structure

```
Game/
├── classes/
│   ├── Vector2.lua          # 2D vector math utilities
│   ├── Window.lua           # Window management system
│   ├── Camera.lua           # Camera and viewport system
│   ├── PlayerShip.lua       # Player ship rendering and animation
│   ├── Planet.lua           # Planet generation and rendering
│   ├── World.lua            # World generation and management
│   └── Game.lua             # Main game loop and coordination
├── utils/
│   └── constants.lua        # Game constants and configuration
├── main.lua                 # Love2D entry point
└── conf.lua                 # Game configuration
```

## Running the Game

1. Ensure Love2D is installed
2. Navigate to the Game directory
3. Run: `love .`
4. Use mouse to drag window and explore space
5. Resize window edges to change view

## Customization

### Constants
Edit `utils/constants.lua` to modify:
- Window size and position
- World size and planet count
- Planet sizes and colors
- Ship properties
- Movement boundaries

### World Generation
Modify the seed in constants to generate different worlds:
```lua
constants.WORLD_SEED = 42  -- Change this number
```

### Planet Generation
Adjust planet parameters in the Planet class:
- Size ranges
- Color schemes
- Ring generation
- Surface detail patterns

## Future Enhancements

- Multiple star systems
- Space stations and asteroids
- Ship upgrades and customization
- Mission system
- Sound effects and music
- Particle effects
- Multiplayer support

## Performance Notes

- The game is optimized for smooth 60 FPS
- Window movement is tracked efficiently
- Only visible objects are rendered
- Coordinate transformations are minimized
- Memory usage is kept low with simple shapes

Enjoy exploring the vast reaches of space!
