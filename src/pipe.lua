require('util/class')

Pipe = class(Updatable)
function Pipe:init(id)
  self.id = id
  self.x = 0
  self.y = 0
  self.color = { math.random(0, 255), math.random(0, 255), math.random(0, 255) } 
  
  self.time = level.pipeTime
  self.speed = level.waterSpeed
  self.waterColor = { 45, 252, 7 }
  
  self.color1 = self.color;
  self.color2 = self.waterColor;
  
  self.xWaterFrom = 0
  self.yWaterFrom = 0
  
  self.animationOrientation = 0
  
  
  self.filled = false
end

function Pipe:use( x, y )
  self.x = x
  self.y = y 
end

--[[function Pipe:filledWithWater()
  self.filled = true  
end]]--

function Pipe:draw()
  self:drawPipe( self.x * level.map.tileWidth, self.y * level.map.tileHeight )
end

function Pipe:drawAsAvailable(index)
  self:drawPipe( 0, level.map.tileHeight * ( 5 - index ) )
  end

function Pipe:drawPipe(x, y)
  love.graphics.draw(self.image, x, y)
  if self.animation then    
    love.graphics.draw(self.animation, x + level.map.tileWidth/2, y + level.map.tileHeight/2, self:getAnimationRotation(), self:getAnimationScaleX(), self:getAnimationScaleY(), level.map.tileWidth/2, level.map.tileHeight/2)
  end
end

function Pipe:getAnimationRotation()
  return 0
end

function Pipe:getAnimationScaleX()
  return 1
end

function Pipe:getAnimationScaleY()
  return 1
end

function Pipe:update(dt)
  self.time = self.time - self.speed * dt       
  
  if self.time <= 0 and not self.filled then
    self.filled = true
    flowToPipe() 
  end
  
  self:animate()  
end

function Pipe:animate()
  local animationIndex = table.getn( self.animationImages ) - math.floor( math.abs( self.time ) / self.animThreshold )
  if not self.filled then
    self.animation = self.animationImages[ animationIndex ]
  else
    self.animation = self.animationImages[ table.getn( self.animationImages ) - math.fmod( math.abs( animationIndex ), 2 ) ]
  end    
end

function Pipe:waterFrom(x, y)
  self.xWaterFrom = x
  self.yWaterFrom = y
  self.time = level.pipeTime
  self.speed = level.waterSpeed
end

function Pipe:getDebugString()
  local xOff, yOff = self:getOffsetForNextPipe()
  return string.format("x[%d] y[%d] next x[%d] y[%d]", self.x, self.y, self.x + xOff, self.y + yOff)
end


HorizontalPipe = class( Pipe )
function HorizontalPipe:init(id)
  Pipe.init(self, id)
  self.image = level.map.horizontalPipeImage
  self.animationImages = level.map.horizontalPipeImageAnim
  self.animThreshold = math.floor( level.pipeTime / ( table.getn( self.animationImages ) - 1 ) )  
end

function HorizontalPipe:getOffsetForNextPipe()
 return self.xWaterFrom, 0
end

function HorizontalPipe:acceptWaterFrom(x, y)
  return y == 0
end

function HorizontalPipe:getAnimationScaleX()
  if self.xWaterFrom == -1 then 
    return -1
  end  
end

-------------------------------------
VerticalPipe = class( Pipe )
function VerticalPipe:init(id)
  Pipe.init(self, id)
  self.image = level.map.verticalPipeImage
  self.animationImages = level.map.verticalPipeImageAnim
  self.animThreshold = math.floor( level.pipeTime / ( table.getn( self.animationImages ) - 1 ) )  
end

function VerticalPipe:acceptWaterFrom(x, y)
  return x == 0
end

function VerticalPipe:getOffsetForNextPipe()
 return 0, self.yWaterFrom
end

function VerticalPipe:getAnimationScaleY()
  if self.yWaterFrom == -1 then 
    return 1
  end
  
  return -1
end

-------------------------------------
CrossPipe = class( Pipe )
function CrossPipe:init(id)
  Pipe.init(self, id)
  self.image = level.map.crossPipeImage
  self.vFilled = false
  self.vAnimationEnable = false
  self.vAnimationImages = level.map.verticalPipeImageAnim
  self.vAnimThreshold = math.floor( level.pipeTime / ( table.getn( self.vAnimationImages ) - 1 ) )
  self.hFilled = false
  self.hAnimationEnable = false  
  self.hAnimationImages = level.map.horizontalPipeImageAnim
  self.hAnimThreshold = math.floor( level.pipeTime / ( table.getn( self.hAnimationImages ) - 1 ) )  
end

function CrossPipe:acceptWaterFrom(x, y)
  return true
end

function CrossPipe:getOffsetForNextPipe()
 return self.xWaterFrom, self.yWaterFrom
end

function CrossPipe:waterFrom(x, y)
  Pipe.waterFrom(self, x, y)
  if x ~= 0 then 
    self.hAnimationEnable = true
    self.hScale = x;
  elseif y ~= 0 then 
    self.vAnimationEnable = true
    self.vScale = -y;
  end  
end

function CrossPipe:drawPipe(x, y)
  love.graphics.draw(self.image, x, y)
  if self.vAnimation then    
    love.graphics.draw(self.vAnimation, x + level.map.tileWidth/2, y + level.map.tileHeight/2, 0, 1, self.vScale, level.map.tileWidth/2, level.map.tileHeight/2)
  end
  if self.hAnimation then    
    love.graphics.draw(self.hAnimation, x + level.map.tileWidth/2, y + level.map.tileHeight/2, 0, self.hScale, 1, level.map.tileWidth/2, level.map.tileHeight/2)
  end
end

function CrossPipe:update(dt)
  self.time = self.time - self.speed * dt       
  
  if self.xWaterFrom ~= 0 then
    if self.time <= 0 and not self.hFilled then
      self.filled = true 
      self.hFilled = true
      flowToPipe()
    end 
  end
  
  if self.yWaterFrom ~= 0 then
    if self.time <= 0 and not self.vFilled then
      self.filled = true 
      self.vFilled = true
      flowToPipe()
    end 
  end
  
  if self.vAnimationEnable then
    self.vAnimation = self:animate(self.vAnimationImages, self.vAnimThreshold, self.vFilled)  
  end
  
  if self.hAnimationEnable then
    self.hAnimation = self:animate(self.hAnimationImages, self.hAnimThreshold, self.hFilled)  
  end
end

function CrossPipe:animate(images, thresold, filled)
  local animationIndex = table.getn( images ) - math.floor( math.abs( self.time ) / thresold )
 
    if not filled then
      return images[ animationIndex ]
    else
      return images[ table.getn( images ) - math.fmod( animationIndex, 2 ) - 1 ]
    end    
end


-------------------------------------
AnglePipe = class( Pipe )
function AnglePipe:init(id)
  Pipe.init(self, id)
  self.animationImages = level.map.downRightPipeImageAnim
  self.animThreshold = math.floor( level.pipeTime / ( table.getn( self.animationImages ) - 1 ) )  
end

-------------------------------------
AngleLeftUpPipe = class( AnglePipe )
function AngleLeftUpPipe:init(id)
  AnglePipe.init(self, id)
  self.image = level.map.leftUpPipeImage
end

function AngleLeftUpPipe:acceptWaterFrom(x, y)
  return x == 1 or y == 1
end

function AngleLeftUpPipe:getOffsetForNextPipe()
 if self.xWaterFrom == 1 then
  return 0, -1
 end 
 return -1, 0
end

function AngleLeftUpPipe:getAnimationScaleY()
  return -1
end

function AngleLeftUpPipe:getAnimationScaleX()
  if self.yWaterFrom == 1 then
    return -1
  end
  
  return 1
end

function AngleLeftUpPipe:getAnimationRotation()
  if self.xWaterFrom == 1 then
    return -math.pi/2
  end
  
  return 0
end

-------------------------------------
AngleLeftDownPipe = class( AnglePipe )
function AngleLeftDownPipe:init(id)
  AnglePipe.init(self, id)
  self.image = level.map.leftDownPipeImage
end


function AngleLeftDownPipe:acceptWaterFrom(x, y)
  return x == 1 or y == -1
end

function AngleLeftDownPipe:getOffsetForNextPipe()
 if self.xWaterFrom == 1 then
  return 0, 1
 end 
 return -1, 0
end

function AngleLeftDownPipe:getAnimationScaleX()
  if self.yWaterFrom == -1 then
    return -1
  end
  
  return 1
end

function AngleLeftDownPipe:getAnimationRotation()
  if self.xWaterFrom == 1 then 
    return math.pi/2
  end
  
  return 0
end

-------------------------------------
AngleUpRightPipe = class( AnglePipe )
function AngleUpRightPipe:init(id)
  AnglePipe.init(self, id)
  self.image = level.map.upRightPipeImage
end

function AngleUpRightPipe:acceptWaterFrom(x, y)
  return x == -1 or y == 1
end

function AngleUpRightPipe:getOffsetForNextPipe()
 if self.xWaterFrom == -1 then
  return 0, -1
 end 
 return 1, 0
end

function AngleUpRightPipe:getAnimationScaleY()
  if self.yWaterFrom == 1 then
    return -1
  end
  
  return 1
end

function AngleUpRightPipe:getAnimationRotation()
  if self.xWaterFrom == -1 then 
    return -math.pi/2
  end
  
  return 0
end


-------------------------------------
AngleDownRightPipe = class( AnglePipe )
function AngleDownRightPipe:init(id)
  AnglePipe.init(self, id)
  self.image = level.map.downRightPipeImage
end

function AngleDownRightPipe:acceptWaterFrom(x, y)
  return x == -1 or y == -1
end

function AngleDownRightPipe:getOffsetForNextPipe()
 if self.xWaterFrom == -1 then
  return 0, 1
 end 
 return 1, 0
end

function AngleDownRightPipe:getAnimationScaleY()
  if self.xWaterFrom == -1 then
    return -1
  end
  
  return 1
end

function AngleDownRightPipe:getAnimationRotation()
  if self.xWaterFrom == -1 then 
    return math.pi/2
  end
  
  return 0
end


-------------------------------------
StartPipe = class( Pipe )

function StartPipe:acceptWaterFrom(x, y)
  return false
end

function StartPipe:getOffsetForNextPipe()
 return 0, -1 
end

function StartPipe:drawPipe(x, y)
end


EndPipe = class( Pipe )

function EndPipe:acceptWaterFrom(x, y)
  return x == 0 and y == 1
end

function EndPipe:getOffsetForNextPipe()
 return 0, 0
end

function EndPipe:drawPipe(x, y)
end

