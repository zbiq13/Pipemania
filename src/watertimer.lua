require('util/class')

Watertimer = class(Updatable)
function Watertimer:init()
  self.time = level.initialTime
  self.speed = level.waterSpeed
  self.color = { 45, 252, 7 }
end

function Watertimer:update( dt )
  if self.time > 0 then
    self.time = self.time - self.speed * dt
  else
    startFlowingWater(); 
  end 
end

function Watertimer:draw()
  love.graphics.setColor( self.color )
  love.graphics.rectangle( 'fill', 5, 400 - self.time, 10, self.time )  
end

function Watertimer:getDebugString()
  return "watertimer"
end