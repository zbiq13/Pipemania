require('util/class')

Pipe = class()
function Pipe:init()
  self.x = 0
  self.y = 0
  self.color = { math.random(0, 255), math.random(0, 255), math.random(0, 255) } 
end

function Pipe:use( x, y )
  self.x = x
  self.y = y 
end

function Pipe:draw()
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', self.x * level.map.tileWidth, self.y * level.map.tileHeight, level.map.tileWidth, level.map.tileHeight)
end

function Pipe:drawAsAvailable(index)
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', 0, level.map.tileHeight * ( 5 - index ), level.map.tileWidth, level.map.tileHeight)
end