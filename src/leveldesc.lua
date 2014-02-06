require('util/class')

function readLevelDescs()
  levelDescs = {}
  
  defaultLevel = 
  {
    xSize = 10,
    ySize = 8,
    startPoint = { x = 'random', y = 'random' },
    endPoint = { x = 'random', y = 'random' },
    lamps = {},
    initialTime = 100,
    pipeTime = 40,
    waterSpeed = 10,
    tileImage = love.graphics.newImage( "img/tile.gif" ),  
    startImage = love.graphics.newImage( "img/start.gif" ),
    endImage = love.graphics.newImage( "img/end.gif" ),
    backgroundImage = love.graphics.newImage( "img/background800640.png" ),
    
    verticalPipeImage = love.graphics.newImage( "img/pipe1.png" ),
    horizontalPipeImage = love.graphics.newImage( "img/pipe2.png" ),
    crossPipeImage = love.graphics.newImage( "img/pipe3.png" ),
    leftUpPipeImage = love.graphics.newImage( "img/pipe6.png" ),
    leftDownPipeImage = love.graphics.newImage( "img/pipe7.png" ),
    upRightPipeImage = love.graphics.newImage( "img/pipe5.png" ),
    downRightPipeImage = love.graphics.newImage( "img/pipe4.png" ),
    
    verticalPipeImageAnim = {},
    horizontalPipeImageAnim = {},    
    downRightPipeImageAnim = {},
    
    lampImage = love.graphics.newImage("img/lamps.png"),
    
    enemiesNo = 0,
    enemyImageAnim = {},
    
    circlesNo = 0
  }
  
  local animDir = love.filesystem.getDirectoryItems("img/pipe1anim")
  for k, file in ipairs(animDir) do
    table.insert(defaultLevel.verticalPipeImageAnim, love.graphics.newImage("img/pipe1anim/"..file) )
  end
  
  animDir = love.filesystem.getDirectoryItems("img/pipe2anim")
  for k, file in ipairs(animDir) do
    table.insert(defaultLevel.horizontalPipeImageAnim, love.graphics.newImage("img/pipe2anim/"..file) )
  end
  
  animDir = love.filesystem.getDirectoryItems("img/pipe4anim")
  for k, file in ipairs(animDir) do
    table.insert(defaultLevel.downRightPipeImageAnim, love.graphics.newImage("img/pipe4anim/"..file) )
  end
  
  animDir = love.filesystem.getDirectoryItems("img/enemy")
  for k, file in ipairs(animDir) do
    table.insert(defaultLevel.enemyImageAnim, love.graphics.newImage("img/enemy/"..file) )
  end
  
  levelDescsDir = love.filesystem.getDirectoryItems("levels")
  for k, file in ipairs(levelDescsDir) do
    addLevel(love.filesystem.load("levels/"..file)() )
  end
end


function addLevel( level )
  for key, value in pairs(defaultLevel) do 
    if not level[ key ] then
      level[ key ] = value
    end
  end

  table.insert( levelDescs, level )
end


