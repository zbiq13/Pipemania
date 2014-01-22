require('camera')
require('watertimer')
require('level')
require('player')
require('pipe')


function love.load()
  generateLevel()
  
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  
  xStart = ( width - ( level.map.tileWidth * level.map.xSize ) ) / 2
  yStart = ( height - ( level.map.tileHeight * level.map.ySize ) ) / 2

  love.keyboard.setKeyRepeat( true )
  camera:setPosition( -xStart, -yStart )  
end

function love.update(dt)
  watertimer:update( dt )
end

function generateLevel()
  level = Level(1)
  player = Player(level)
  watertimer = Watertimer()
  pipes = {}
  
  for i = 1, 5 do
    generatePipe()
  end
  
  pipesUsed = {}
end

function generatePipe()
  table.insert( pipes, Pipe() )
end

function usePipe()
  local pipe = table.remove( pipes, 1 )
  pipe:use( player.x, player.y )
  table.insert( pipesUsed, pipe )
  generatePipe()
end

function love.keypressed(key, isrepeat)
  player:keypressed(key)
  
  if key == ' ' then
      usePipe()
   end  
 
  if key == "escape" then
      love.event.quit()
  end
  
  if key == "l" then
      generateLevel()
  end

end


function love.draw()
  
  --draw available pieces
  for i, pipe in pairs(pipes) do
    pipe:drawAsAvailable( i )
--    love.graphics.setColor(p.color)
--    love.graphics.rectangle('fill', 0, level.map.tileHeight * ( 5 - i ), level.map.tileWidth, level.map.tileHeight)
  end
  
  watertimer:draw()

  camera:set()
  level:draw()
  

  --draw used pieces
  for i, pipe in pairs(pipesUsed) do
    pipe:draw()
--    love.graphics.setColor(p.color)
--    love.graphics.rectangle('fill', p.x * level.map.tileWidth, p.y * level.map.tileHeight, level.map.tileWidth, level.map.tileHeight)
  end
 
 -- player
 player:draw()
 
 camera:unset()
end

