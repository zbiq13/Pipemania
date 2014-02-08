require('camera')
require('leveldesc')
require('level')
require('player')
require('pipe')
require('lamp')
require('enemy')
require('pipedebug')
require('goalinfo')

function love.load()
  love.window.setMode(1200, 700, {fullscreen=false, vsync=false, minwidth=800, minheight=600})
  
  math.randomseed(os.time())
  
  font = love.graphics.newFont( 42 )
  debugFont = love.graphics.newFont( 12 )
  showText = false
  blinkRate = 10
  blinkSpeed = 25
  blink = blinkRate
  
  babeScale = 1
  
  underAge = false
  difficulty = 2
  
  pipeTypes = {}
  table.insert( pipeTypes, HorizontalPipe )
  table.insert( pipeTypes, VerticalPipe )
  table.insert( pipeTypes, CrossPipe )
  table.insert( pipeTypes, AngleLeftUpPipe )
  table.insert( pipeTypes, AngleLeftDownPipe )
  table.insert( pipeTypes, AngleUpRightPipe )
  table.insert( pipeTypes, AngleDownRightPipe )
  
  --audio
  electricWire = love.audio.newSource("audio/39542__the-bizniss__line-in-noise.wav", "static")
  putPipe = love.audio.newSource("audio/putpipe.wav", "static")
  putPipe:setPitch(0.5)
  lostSound = love.audio.newSource("audio/lose.mp3")  
  babeTheme = love.audio.newSource("audio/babetheme.mp3")
  bulbOn = love.audio.newSource("audio/bulbon.wav", "static")
  
  readLevelDescs()
  generateLevel()
  
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  
  xStart = ( width - ( level.map.tileWidth * level.map.xSize ) ) / 2
  yStart = ( height - ( level.map.tileHeight * level.map.ySize ) ) / 2

  love.keyboard.setKeyRepeat( true )
  camera:setPosition( -xStart, -yStart )
  
  startImage = love.graphics.newImage("img/startgame.png")
  askAgeImage = love.graphics.newImage("img/agequestion.png")
  overAgeFocusImage = love.graphics.newImage("img/over18_focus.png")
  overAgeImage = love.graphics.newImage("img/over18.png")
  underAgeFocusImage = love.graphics.newImage("img/under18_focus.png")
  underAgeImage = love.graphics.newImage("img/under18.png")
  
  
  chooseDifficultyImage = love.graphics.newImage("img/choosedifficulty.png")
  
  arrowRedImage = love.graphics.newImage("img/arrowred.png")
  arrowGreenImage = love.graphics.newImage("img/arrowgreen.png")
  
  bulbOnImage = love.graphics.newImage("img/bulbon.png")
  bulbOffImage = love.graphics.newImage("img/bulboff.png")
  
  state = 'start'
  babeTheme:setLooping(true)
  babeTheme:play()
  
end

function love.update(dt)
  --if not lost and not wonLevel then
  if state == "playing" then
    
    --update start
    if waterFlowing then
      startPipe:update(dt)
    end
    
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
      babeScale = - babeScale
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
  player = Player(level)
  
  updatable = level.watertimer
  pipes = {}
  pipeIndex = 1
  
  babeTheme:stop()
  
  waterFlowing = false
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

  startPipe = StartPipe()
  startPipe:use(level.startPoint.x, level.startPoint.y)
  pipesMatrix[level.startPoint.x][level.startPoint.y] = startPipe
  
  endPipe = EndPipe()
  endPipe:use(level.endPoint.x, level.endPoint.y)
  pipesMatrix[level.endPoint.x][level.endPoint.y] = endPipe
  
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
  if state ~= "playing" then
    return
  end
  
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
  
  putPipe:play()
end

function startFlowingWater()
  local pipe = getPipeFromMatrix(level.startPoint.x, level.startPoint.y-1)
  if pipe and pipe:acceptWaterFrom(0,-1) then
    waterFlowing = true
    pipe:waterFrom(0,-1)
    updatable = pipe 
    electricWire:setVolume(3.0)
    electricWire:setLooping(true)
    electricWire:play()
  else
    gameLost()
  end
end

function flowToPipe()
  if updatable:is_a(EndPipe) then
      level:endPointReached()
      level:checkResult()
      return      
  end
  
  local x, y = updatable:getOffsetForNextPipe()
  local pipe = getPipeFromMatrix(updatable.x + x, updatable.y + y)
  if pipe and pipe:acceptWaterFrom(x, y) then
      updatable = pipe 
      updatable:waterFrom(x, y)
  else
    gameLost()
  end
end

function gameLost()
  lostSound:setVolume(2.0)
  lostSound:play()
  electricWire:stop()
  lost = true
  state = 'gamelost'
  --todo
end

function levelWon()
  electricWire:stop()
  babeTheme:setLooping(true)
  babeTheme:play()
    
  wonLevel = true
  state = 'levelwon'
end

function gameWon()
  state = 'gamewon'
  --todo
end

function love.keypressed(key, isrepeat)
  
  if state == "playing" then
    player:keypressed(key) 
  
    if key == ' ' then
        usePipe()
    end
  end
   
  if state == "askage" then
    askAgeKeyPressed(key)  
  end
  
  if state == "choosedifficulty" then
    chooseDifficultyKeyPressed(key)  
  end
  
  
  if key == "escape" then
      love.event.quit()
  end
  
  if key == "return" or key == ' ' then
  
    if state == "start" then
      state = "askage"
    elseif  state == "askage" then
      state = "choosedifficulty"
    elseif state == "choosedifficulty" then
      babeTheme:stop()
      state = "playing"
      generateLevel()
    elseif state == "levelwon" then
      state = "playing"
      table.remove(levelDescs, 1)
      generateLevel()
    elseif state == "gamelost" then 
      state = "playing"
      generateLevel()
    end
    
  end
  
  if key == "l" then
      state = "playing"
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
  --love.graphics.setColor( 208, 199, 183 )
  love.graphics.setColor( 255, 255, 255 )
  love.graphics.rectangle("fill",0,0,width,height)
  love.graphics.reset()
  
  if state == "start" then
    drawStart()
  elseif state == "askage" then
    drawAskAge()
  elseif state == "choosedifficulty" then
    drawChooseDifficulty()
  elseif state == "beforelevel" then
    drawGoals()
  elseif state == "playing" or state == "gamelost" then
    level:draw()
  elseif state == "levelwon" then
    drawBabe()
  end
  
end


function drawBabe()
  love.graphics.draw(level.babeImage,width/2,0,0,babeScale,1,level.babeImage:getWidth()/2,0)
  drawPressToContinue()
end

function drawGoals()
  --love.graphics.draw(level.babeImage,200+275,350,0,babeScale,1,275,350)
end

function drawStart()
  love.graphics.draw(startImage,width/2,0,0,1,1,startImage:getWidth()/2,0)
  drawPressToContinue()
end

function drawAskAge()
  love.graphics.draw(askAgeImage,0,0)

  if underAge then
    love.graphics.draw(overAgeImage,250,375)
    love.graphics.draw(underAgeFocusImage,600,370)
  else
    love.graphics.draw(overAgeFocusImage,250,375)
    love.graphics.draw(underAgeImage,600,370)
  end
  drawPressToContinue()
end

function askAgeKeyPressed(key)
  if key == 'left' and underAge then
    underAge = false
    putPipe:play()
  elseif key == 'right' and not underAge  then
    underAge = true
    putPipe:play()
  end
end  

function drawChooseDifficulty()
  love.graphics.draw(chooseDifficultyImage,0,0)

  love.graphics.setColor(100, 100, 100)
  love.graphics.rectangle('fill', 300, 400, 100, 100)
  love.graphics.rectangle('fill', 550, 400, 100, 100)
  love.graphics.rectangle('fill', 800, 400, 100, 100)
  love.graphics.setColor(230, 30, 30)
  local chosen = 300
  if difficulty == 2 then
    chosen = 550
  elseif difficulty == 3 then
    chosen = 800
  end
  
  love.graphics.rectangle('line', chosen, 400, 100, 100)
  drawPressToContinue()
end

function chooseDifficultyKeyPressed(key)
  if key == 'left' and difficulty > 1 then
    difficulty = difficulty - 1
    putPipe:play()    
  elseif key == 'right' and difficulty < 3 then
    difficulty = difficulty + 1
    putPipe:play()
  end
  
end

function drawPressToContinue()
  love.graphics.setColor( { 255, 0, 0 } )
  love.graphics.setFont( font )
  love.graphics.printf("Press [enter] to continue", width - 625, height - 50, 600, "right" )
end      
