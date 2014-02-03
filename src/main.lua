require('camera')
require('watertimer')
require('leveldesc')
require('level')
require('player')
require('pipe')
require('pipedebug')


function love.load()
  math.randomseed(os.time())
  
  pipeTypes = {}
  table.insert( pipeTypes, HorizontalPipe )
  table.insert( pipeTypes, VerticalPipe )
  table.insert( pipeTypes, CrossPipe )
  table.insert( pipeTypes, AngleLeftUpPipe )
  table.insert( pipeTypes, AngleLeftDownPipe )
  table.insert( pipeTypes, AngleUpRightPipe )
  table.insert( pipeTypes, AngleDownRightPipe )
  
  readLevelDescs()
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
  if table.getn(levelDescs) == 0 then
    gameWon()
    return
  end
  level = Level(levelDescs[1])
  table.remove(levelDescs, 1)
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
  table.insert(pipes, pipeTypes[math.random(1, table.getn(pipeTypes))]())
end

function getPipeFromMatrix(x, y)
  --pass map edge
  if x < 0 and level:canPassWallAt(x, y) then
    x = level.map.xSize - 1
  elseif x > level.map.xSize - 1 and level:canPassWallAt(x, y) then
    x = 0
  end
  
  if y < 0 and level:canPassWallAt(x, y) then
    y = level.map.ySize - 1
  elseif y > level.map.ySize - 1 and level:canPassWallAt(x, y) then
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
    gameLost()
  end
end

function flowToPipe()
  local x, y = updatable:getOffsetForNextPipe()
  local pipe = getPipeFromMatrix(updatable.x + x,updatable.y + y)
  if pipe and pipe:acceptWaterFrom(x, y) then
    updatable = pipe 
    updatable:waterFrom(x, y)
  else
    gameLost()
  end
end

function gameLost()
  lost = true
  --todo
end

function gameWon()
  --todo
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
  
  if key == "f" then
      hurryWater()
  end

end


function hurryWater()
  level.waterSpeed = 100
  if updatable then
    updatable.speed = level.waterSpeed
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

