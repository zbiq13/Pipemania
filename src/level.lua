require('util/class')
require('point')


Level = class()
function Level:init(levelDesc)
  self.map = 
  {
    xSize = levelDesc.xSize,
    ySize = levelDesc.ySize,
    tileWidth = 40,
    tileHeight = 40,
    tileImage = love.graphics.newImage( "img/tile.gif" ),    
  }
  
  self.startPoint = Point(levelDesc.startPoint.x, levelDesc.startPoint.y, self.map.xSize, self.map.ySize )
  --[[if levelDesc.startPoint.x == 'random' then
    self.startPoint.x = math.random(0, self.map.xSize - 1)
  else
    self.startPoint.x = levelDesc.startPoint.x
  end
  
  if levelDesc.startPoint.y == 'random' then
    self.startPoint.y = math.random(0, self.map.ySize - 1)
  else
    self.startPoint.y = levelDesc.startPoint.y
  end]]--
  
  self.startColor = { 0, 0, 0 }
  self.pipeTime = levelDesc.pipeTime
  self.waterSpeed = levelDesc.waterSpeed
  self.initialTime = levelDesc.initialTime
end


function Level:canPassWallAt(x, y)
  return true
end


function Level:draw()
  
  love.graphics.reset()
  for x=0, self.map.xSize - 1 do
    for y=0, self.map.ySize - 1 do
      love.graphics.draw(self.map.tileImage, x * self.map.tileWidth, y * self.map.tileHeight); 
    end
  end
  
  love.graphics.setColor(self.startColor)
  love.graphics.rectangle('fill', self.startPoint.x * self.map.tileWidth, self.startPoint.y * self.map.tileHeight, self.map.tileWidth, self.map.tileHeight)
  
end