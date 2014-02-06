require('util/class')

Point = class()
function Point:init(pointDesc, width, height)
  if pointDesc.x == 'random' then
    self.x = math.random(0, width - 1)
  else
    self.x = pointDesc.x
  end
  
  if pointDesc.y == 'random' then
    self.y = math.random(0, height - 1)
  else
    self.y = pointDesc.y
  end
end

function Point:draw(color)
  love.graphics.setColor(color)
  love.graphics.rectangle('fill', self.x * level.map.tileWidth, self.y * level.map.tileHeight, level.map.tileWidth, level.map.tileHeight)
end

function Point:drawWithImage(image)
  love.graphics.draw(image, self.x * level.map.tileWidth, self.y * level.map.tileHeight)
end