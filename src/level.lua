require('util/class')
require('point')
require('lamp')


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
    horizontalPipeImageAnim = levelDesc.horizontalPipeImageAnim,
    downRightPipeImageAnim = levelDesc.downRightPipeImageAnim,
    
    lampImage = levelDesc.lampImage
  }
  
  self.startPoint = Point(levelDesc.startPoint, self.map.xSize, self.map.ySize)
  repeat 
    self.endPoint = Point(levelDesc.endPoint, self.map.xSize, self.map.ySize)
  until ( levelDesc.endPoint.x ~= 'random' or math.fmod( math.abs( self.endPoint.x - self.startPoint.x ), self.map.xSize ) > 2 ) and
    ( levelDesc.endPoint.y ~= 'random' or math.fmod( math.abs( self.endPoint.y - self.startPoint.y ), self.map.ySize ) > 2 )
  
  self.lamps = {}
  for i, lampDesc in next, levelDesc.lamps, nil do
    table.insert(self.lamps, Lamp(lampDesc))
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


function Level:checkResult()
  local lampsLighted = true
  
  for i, lamp in next,self.lamps,nil do
    lampsLighted = lampsLighted and lamp.lighted
  end 
  
  if lampsLighted then
    levelWon()
  else
    gameLost()
  end
end


function Level:draw()
  
  love.graphics.reset()
  love.graphics.draw(self.map.backgroundImage, x, y)
  
  self.startPoint:drawWithImage(self.map.startImage)
  self.endPoint:drawWithImage(self.map.endImage)
  
  for i, lamp in next,self.lamps,nil do
    lamp:draw()
  end 
end