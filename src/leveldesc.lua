require('util/class')

function readLevelDescs()
  levelDescs = {}
  
  defaultLevel = 
  {
    xSize = 10,
    ySize = 8,
    startPoint = { x = 'random', y = 'random' },
    initialTime = 100,
    pipeTime = 40,
    waterSpeed = 10,
    tileImage = love.graphics.newImage( "img/tile.gif" ),  
    startImage = love.graphics.newImage( "img/start.gif" ),
    endImage = love.graphics.newImage( "img/end.gif" )  
  }
  
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


