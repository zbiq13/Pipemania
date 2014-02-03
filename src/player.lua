require('util/class')


Player = class()
function Player:init( level )
  self.level = level
  self.x = 0
  self.y = 0
  self.width = level.map.tileWidth
  self.height = level.map.tileHeight
  self.color = { 230, 30, 30 }
end


function Player:keypressed( key )
  if key == 'left' and self.x > 0 then
    self.x = self.x - 1
  elseif key == 'right' and self.x < level.map.xSize - 1  then
    self.x = self.x + 1
  elseif key == 'up' and self.y > 0 then
    self.y = self.y - 1
  elseif key == 'down' and self.y < level.map.ySize - 1  then
    self.y = self.y + 1
  end
end


function Player:draw()
  love.graphics.setColor(self.color)
  love.graphics.rectangle('line', self.x * level.map.tileWidth, self.y * level.map.tileHeight, self.width, self.height)
end
