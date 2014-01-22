require('util/class')


Level = class()
function Level:init( difficulty )
  self.map = 
  {
    xSize = 10,
    ySize = 7,
    tileWidth = 40,
    tileHeight = 40,
    tileImage = love.graphics.newImage( "img/tile.gif" )
  }
end


function Level:draw()
  love.graphics.reset()
  for x=0, self.map.xSize do
    for y=0, self.map.ySize do
      love.graphics.draw(self.map.tileImage, x * self.map.tileWidth, y * self.map.tileHeight); 
    end
  end
end