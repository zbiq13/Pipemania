require('camera')
require('watertimer')
require('level')
require('player')
require('pipe')
require('pipedebug')


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
  if not lost then
    updatable:update(dt)  
  end
end

function generateLevel()
  level = Level(1)
  player = Player(level)
  watertimer = Watertimer()
  updatable = watertimer
  pipes = {}
  pipeIndex = 1;
  lost = false
  
  for i = 1, 5 do
    generatePipe()
  end
  
  pipesUsed = {}
  pipesMatrix = {}
  for i = 0, level.map.xSize do
    pipesMatrix[i] = {}
  end
end

function generatePipe()
  local i = math.random( 0, 6 )
  if i == 0 then
    table.insert( pipes, HorizontalPipe() )
  elseif i == 1 then
    table.insert( pipes, VerticalPipe() )
  elseif i == 2 then
    table.insert( pipes, CrossPipe() )
  elseif i == 3 then
    table.insert( pipes, AngleLeftUpPipe() )
  elseif i == 4 then
    table.insert( pipes, AngleLeftDownPipe() )
  elseif i == 5 then
    table.insert( pipes, AngleUpRightPipe() )
  elseif i == 6 then
    table.insert( pipes, AngleDownRightPipe() )

  end
end

function getPipeFromMatrix(x, y)
  --przechodzenie przez krawedzie planszy
  if x < 0 and level:canPassWallAt(x, y) then
    x = level.map.xSize
  elseif x > level.map.xSize and level:canPassWallAt(x, y) then
    x = 0
  end
  
  if y < 0 and level:canPassWallAt(x, y) then
    y = level.map.ySize
  elseif y > level.map.ySize and level:canPassWallAt(x, y) then
    y = 0
  end
  
  return pipesMatrix[x][y]
end

function setPipeInMatrix(pipe, x, y)
  pipesMatrix[x][y] = pipe
end

function usePipe()
  -- do not use if on the start position
  if player.x == level.xStart and player.y == level.yStart then
    return
  end
  
  local pipe = table.remove( pipes, 1 )
  pipe:use( player.x, player.y )
  table.insert( pipesUsed, pipe )
  setPipeInMatrix(pipe, player.x, player.y)
  generatePipe()
end

function startFlowingWater()
  local pipe = getPipeFromMatrix(level.xStart, level.yStart-1)
  if pipe and pipe:acceptWaterFrom(0,-1) then
    pipe:waterFrom(0,-1)
    updatable = pipe 
  else
    lost = true
  end
end

function flowToPipe()
  local x, y = updatable:getOffsetForNextPipe()
  local pipe = getPipeFromMatrix(updatable.x + x,updatable.y + y)
  if pipe and pipe:acceptWaterFrom(x, y) then
    updatable = pipe 
    updatable:waterFrom(x, y)
  else
    lost = true
  end
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
  printDebug()
  
  
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

