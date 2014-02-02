require('util/class')


Level = class()
function Level:init( difficulty )
  self.map = 
  {
    xSize = 10,
    ySize = 7,
    tileWidth = 40,
    tileHeight = 40,
    tileImage = love.graphics.newImage( "img/tile.gif" ),    
  }
  
  self.xStart = math.random(0, self.map.xSize)
  self.yStart = math.random(0, self.map.ySize)
  self.startColor = { 0, 0, 0 }
  self.pipeTime = 40
end


function Level:canPassWallAt(x, y)
  return true
end


function Level:draw()
  
  love.graphics.reset()
  for x=0, self.map.xSize do
    for y=0, self.map.ySize do
      love.graphics.draw(self.map.tileImage, x * self.map.tileWidth, y * self.map.tileHeight); 
    end
  end
  
  love.graphics.setColor(self.startColor)
  love.graphics.rectangle('fill', self.xStart * self.map.tileWidth, self.yStart * self.map.tileHeight, self.map.tileWidth, self.map.tileHeight)
  
end