require('camera')
require('watertimer')
require('leveldesc')
require('level')
require('player')
require('pipe')
require('lamp')
require('enemy')
require('pipedebug')
require('goalinfo')

function love.load()
  love.window.setMode(1300, 700, {fullscreen=false, vsync=false, minwidth=800, minheight=600})
  math.randomseed(os.time())
  
  font = love.graphics.newFont( 42 )
  debugFont = love.graphics.newFont( 12 )
  showText = false
  blinkRate = 10
  blinkSpeed = 25
  blink = blinkRate
  
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
  if not lost and not wonLevel then
    
    --update pipes
    updatable:update(dt)  
    for i, pipe in pairs(pipesUsed) do
      if pipe.filled then
        pipe:update(dt)
      end
    end
       
    --update enemies
    for i, enemy in next,level.enemies,nil do
        enemy:update(dt)      
    end
    
    --update lamps
    for i, lamp in next,lampsLighted,nil do
        lamp:update(dt)      
    end
    
  else
    blink = blink - dt * blinkSpeed
    if blink < 0 then
      blink = blinkRate
      showText = not showText
    end    
  end
  
end

function generateLevel()
  if table.getn(levelDescs) == 0 then
    gameWon()
    return
  end
  level = Level(levelDescs[1])
  --narazie zapetlam
  table.insert(levelDescs, levelDescs[1])
  table.remove(levelDescs, 1)
  player = Player(level)
  watertimer = Watertimer()
  updatable = watertimer
  pipes = {}
  pipeIndex = 1;
  lost = false
  wonLevel = false
  
  lampsLighted = {}
  
  for i = 1, 5 do
    generatePipe()
  end
  
  pipesUsed = {}
  pipesMatrix = {}
  for i = 0, level.map.xSize do
    pipesMatrix[i] = {}
  end

  pipesMatrix[level.startPoint.x][level.startPoint.y] = StartPipe()
  pipesMatrix[level.endPoint.x][level.endPoint.y] = EndPipe()
  
  for i,lamp in next,level.lamps,nil do
    pipesMatrix[lamp.point.x][lamp.point.y] = lamp
  end 
  
  for i,enemy in next,level.enemies,nil do
    pipesMatrix[enemy.point.x][enemy.point.y] = enemy
  end
end

function generatePipe()
  table.insert(pipes, pipeTypes[math.random(1, table.getn(pipeTypes))](level.pipeSeq))
  level.pipeSeq = level.pipeSeq + 1
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
  
  -- check if usable
  local possiblePipe = getPipeFromMatrix(player.x, player.y);  
  
  if possiblePipe then
    if possiblePipe:is_a( StartPipe ) or
      possiblePipe:is_a( EndPipe ) or
      possiblePipe == updatable or
      possiblePipe:is_a( Lamp ) or
      possiblePipe:is_a( Enemy ) or
      possiblePipe.filled then
        return
    end
  end  
  
  local pipe = table.remove( pipes, 1 )
  pipesUsed[ pipe.id ] = pipe;
  pipe:use( player.x, player.y )
  
  usedAlreadyPipe = getPipeFromMatrix(player.x, player.y)
  if usedAlreadyPipe then
    pipesUsed[ usedAlreadyPipe.id ] = nil
  end
  setPipeInMatrix(pipe, player.x, player.y)
  generatePipe()
end

function startFlowingWater()
  local pipe = getPipeFromMatrix(level.startPoint.x, level.startPoint.y-1)
  if pipe and pipe:acceptWaterFrom(0,-1) then
    pipe:waterFrom(0,-1)
    updatable = pipe 
  else
    gameLost()
  end
end

function flowToPipe()
  local x, y = updatable:getOffsetForNextPipe()
  local pipe = getPipeFromMatrix(updatable.x + x, updatable.y + y)
  if pipe and pipe:acceptWaterFrom(x, y) then
    if pipe:is_a(EndPipe) then
      level:endPointReached()
      level:checkResult()      
    else
      --updatable:filledWithWater()
      updatable = pipe 
      updatable:waterFrom(x, y)
    end
  else
    gameLost()
  end
end

function gameLost()
  lost = true
  --todo
end

function levelWon()
  wonLevel = true
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
  
  if key == "return" and wonLevel then
      generateLevel()
  end
  
  if key == "return" and lost then
      generateLevel()
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
  end
  
  watertimer:draw()
  printDebug()
  printGoalInfo()
  
  
  camera:set()
  level:draw()
  

  --draw used pieces
  for i, pipe in pairs(pipesUsed) do
    pipe:draw()
  end
  
  font = love.graphics.newFont( 30 )
  love.graphics.setFont( font )
  
  
  
  -- player
  player:draw()
 
  if showText then
    love.graphics.setColor( { 255, 0, 0 } )
    love.graphics.setFont( font )
    if wonLevel then
      love.graphics.printf("You won!\npress [enter] to continue", ( level.map.tileWidth * level.map.xSize )/2 - 300, ( level.map.tileHeight * level.map.ySize )/2, 600, "center" )
    end
  
    if lost then
      love.graphics.printf("You lost!\npress [enter] to restart level", ( level.map.tileWidth * level.map.xSize )/2 - 300, ( level.map.tileHeight * level.map.ySize )/2, 600, "center" )
    end
  end 
    
  camera:unset()

end

