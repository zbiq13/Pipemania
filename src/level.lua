require('util/class')
require('point')


Level = class()
function Level:init(levelDesc)
  self.map = 
  {
    xSize = levelDesc.xSize,
    ySize = levelDesc.ySize,
    tileWidth = 80,
    tileHeight = 80,
    tileImage = levelDesc.tileImage,
    startImage = levelDesc.startImage,
    endImage = levelDesc.endImage,    
    backgroundImage = levelDesc.backgroundImage,
    verticalPipeImage = levelDesc.verticalPipeImage,
    horizontalPipeImage = levelDesc.horizontalPipeImage,
    crossPipeImage = levelDesc.crossPipeImage,
    leftUpPipeImage = levelDesc.leftUpPipeImage,
    leftDownPipeImage = levelDesc.leftDownPipeImage,
    upRightPipeImage = levelDesc.upRightPipeImage,
    downRightPipeImage = levelDesc.downRightPipeImage,
    
    verticalPipeImageAnim = levelDesc.verticalPipeImageAnim,
    horizontalPipeImageAnim = levelDesc.horizontalPipeImageAnim
  }
  
  self.startPoint = Point(levelDesc.startPoint, self.map.xSize, self.map.ySize)
  if levelDesc.endPoint then
    repeat 
      self.endPoint = Point(levelDesc.endPoint, self.map.xSize, self.map.ySize)
    until ( levelDesc.endPoint.x ~= 'random' or math.fmod( math.abs( self.endPoint.x - self.startPoint.x ), self.map.xSize ) > 2 ) and
      ( levelDesc.endPoint.y ~= 'random' or math.fmod( math.abs( self.endPoint.y - self.startPoint.y ), self.map.ySize ) > 2 )
  end
  
  self.startColor = { 0, 0, 0 }
  self.pipeTime = levelDesc.pipeTime
  self.waterSpeed = levelDesc.waterSpeed
  self.initialTime = levelDesc.initialTime
  
  self.pipeSeq = 0
end


function Level:canPassWallAt(x, y)
  return true
end


function Level:draw()
  
  love.graphics.reset()
  love.graphics.draw(self.map.backgroundImage, x, y)
  --[[for x=0, self.map.xSize - 1 do
    for y=0, self.map.ySize - 1 do
      love.graphics.draw(self.map.tileImage, x * self.map.tileWidth, y * self.map.tileHeight); 
    end
  end]]--
  
  self.startPoint:drawWithImage(self.map.startImage, self.map.tileWidth, self.map.tileHeight)
  
  if self.endPoint then
    self.endPoint:drawWithImage(self.map.endImage, self.map.tileWidth, self.map.tileHeight)
  end
end