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

function Point:draw(color, tileWidth, tileHeight)
  love.graphics.setColor(color)
  love.graphics.rectangle('fill', self.x * tileWidth, self.y * tileHeight, tileWidth, tileHeight)
end

function Point:drawWithImage(image, tileWidth, tileHeight)
  love.graphics.draw(image, self.x * tileWidth, self.y * tileHeight)
end