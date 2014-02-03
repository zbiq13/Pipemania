require('util/class')


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
  
  if levelDesc.xStart == 'random' then
    self.xStart = math.random(0, self.map.xSize - 1)
  else
    self.xStart = levelDesc.xStart
  end
  
  if levelDesc.yStart == 'random' then
    self.yStart = math.random(0, self.map.ySize - 1)
  else
    self.yStart = levelDesc.yStart
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
  
  love.graphics.setColor(self.startColor)
  love.graphics.rectangle('fill', self.xStart * self.map.tileWidth, self.yStart * self.map.tileHeight, self.map.tileWidth, self.map.tileHeight)
  
end