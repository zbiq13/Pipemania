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
    tileImage = levelDesc.tileImage,
    startImage = levelDesc.startImage,
    endImage = levelDesc.endImage    
  }
  
  self.startPoint = Point(levelDesc.startPoint, self.map.xSize, self.map.ySize)
  if levelDesc.endPoint then
    self.endPoint = Point(levelDesc.endPoint, self.map.xSize, self.map.ySize)
  end
  
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
  
  self.startPoint:drawWithImage(self.map.startImage, self.map.tileWidth, self.map.tileHeight)
  
  if self.endPoint then
    self.endPoint:drawWithImage(self.map.endImage, self.map.tileWidth, self.map.tileHeight)
  end
end