require('util/class')

function readLevelDescs()
  levelDescs = {}
  
  defaultLevel = 
  {
    xSize = 10,
    ySize = 8,
    xStart = 'random',
    yStart = 'random',
    initialTime = 100,
    pipeTime = 40,
    waterSpeed = 10
  }
  
  levelDescsDir = love.filesystem.getDirectoryItems("levels")
  for k, file in ipairs(levelDescsDir) do
    addLevel(love.filesystem.load("levels/"..file)() )
  end
end


function addLevel( level )
  if not level.xSize then
    level.xSize = defaultLevel.xSize
  end
  
  if not level.ySize then
    level.ySize = defaultLevel.ySize
  end
  
  if not level.xStart then
    level.xStart = defaultLevel.xStart
  end
  
  if not level.yStart then
    level.yStart = defaultLevel.yStart
  end
  
  if not level.initialTime then
    level.initialTime = defaultLevel.initialTime
  end
  
  if not level.pipeTime then
    level.pipeTime = defaultLevel.pipeTime
  end
  
  if not level.waterSpeed then
    level.waterSpeed = defaultLevel.waterSpeed
  end
  
  table.insert( levelDescs, level )
end


