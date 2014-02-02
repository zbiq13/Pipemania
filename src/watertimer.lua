require('util/class')

Watertimer = class(Updatable)
function Watertimer:init()
  self.time = 100
  self.speed = 10
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