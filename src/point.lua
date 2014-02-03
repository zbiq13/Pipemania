require('util/class')

Point = class()
function Point:init(_x, _y, width, height)
  if _x == 'random' then
    self.x = math.random(0, width - 1)
  else
    self.x = _x
  end
  
  if _y == 'random' then
    self.y = math.random(0, height - 1)
  else
    self.y = _y
  end
end