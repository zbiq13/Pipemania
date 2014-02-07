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
  self.animationImages = level.map.lampImageAnim
  self.animThreshold = math.floor( self.time / ( table.getn( self.animationImages ) - 1 ) )
  self.animationFramesNo = table.getn( self.animationImages )
  self.imageIndex = 1
  self.animateRate = 5
  self.animateSpeed= 75
  self.blink = self.animateRate
  self.lighted = false
end


function Lamp:draw()
  self.point:drawWithImage( level.map.verticalPipeImage )
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
    table.insert(lampsLighted,self)
    flowToPipe() 
  end
  
  self:animate(dt)  
end

function Lamp:animate(dt)
  self.blink = self.blink - dt * self.animateSpeed
  if self.blink < 0 then
    self.blink = self.animateRate
    self.imageIndex = math.fmod(self.imageIndex, self.animationFramesNo) + 1
    self.image = self.animationImages[ self.imageIndex ] 
  end 
    
  --[[local animationIndex = self.animationFramesNo - math.floor( math.abs( self.time ) / self.animThreshold )
  animationIndex = math.fmod(animationIndex, self.animationFramesNo) + 1
  print("Index: "..animationIndex)
  self.image = self.animationImages[ animationIndex ] ]]--
   
end

function Lamp:getDebugString()
  local xOff, yOff = self:getOffsetForNextPipe()
  return string.format("LAMP x[%d] y[%d] next x[%d] y[%d]", self.point.x, self.point.y, self.point.x + xOff, self.point.y + yOff)
end


