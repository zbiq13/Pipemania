require('util/class')

Watertimer = class(Updatable)
function Watertimer:init(level)
  self.level = level
  self.time = level.initialTime
  self.speed = level.waterSpeed
  self.color = { 45, 252, 7 }
  self.lamp = love.graphics.newImage("img/lamps.png")
  self.lampNo = level.map.ySize
  self.lampsLighted = 0
  self.threshold = math.floor(level.initialTime/self.lampNo)
  self.count = 0
end

function Watertimer:update( dt )
  self.count = self.count + self.speed * dt
  if self.count >= self.threshold then
    self.count = 0
    self.lampsLighted = self.lampsLighted + 1
  end
  
  
  if self.time > 0 then
    self.time = self.time - self.speed * dt
  else
    startFlowingWater(); 
  end 
end

function Watertimer:draw()
  for i=0,self.lampNo-1 do
    love.graphics.setColor(255,255,0)
    if self.lampsLighted <= i then
      love.graphics.reset()
    end
    love.graphics.draw(self.lamp, -self.level.map.tileWidth, i*self.level.map.tileHeight)
  end
end

function Watertimer:getDebugString()
  return "watertimer"
end