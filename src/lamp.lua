require('util/class')
require('point')

Lamp = class()
function Lamp:init(lampDesc)
  self.point = Point(lampDesc, level.map.xSize, level.map.ySize)
  self.x = self.point.x
  self.y = self.point.y
  self.image = level.map.lampImage
  self.time = level.pipeTime
  self.speed = level.waterSpeed
  self.lighted = false
end


function Lamp:draw()
  self.point:drawWithImage( self.image )
end

function Lamp:acceptWaterFrom(x, y)
  return y ~= 0
end

function Lamp:waterFrom(x, y)
  self.waterFrom = y
  self.speed = level.waterSpeed
end

function Lamp:getOffsetForNextPipe()
  return 0, self.waterFrom
end

function Lamp:update(dt)
  self.time = self.time - self.speed * dt       
  
  if self.time <= 0 and not self.lighted then
    self.lighted = true
    level.lampsGoal:lampLighted()
    flowToPipe() 
  end
  
  self:animate()  
end

function Lamp:animate()
end

function Lamp:getDebugString()
  local xOff, yOff = self:getOffsetForNextPipe()
  return string.format("LAMP x[%d] y[%d] next x[%d] y[%d]", self.point.x, self.point.y, self.point.x + xOff, self.point.y + yOff)
end


