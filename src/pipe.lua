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
  
  
  self.filled = false
end

function Pipe:use( x, y )
  self.x = x
  self.y = y 
end

function Pipe:filledWithWater()
  self.filled = true  
end

function Pipe:draw()
  self:drawPipe( self.x * level.map.tileWidth, self.y * level.map.tileHeight )
end

function Pipe:drawAsAvailable(index)
  self:drawPipe( 0, level.map.tileHeight * ( 5 - index ) )
  end

function Pipe:drawPipe(x, y)
  --love.graphics.setColor(self.color)
  --love.graphics.rectangle('fill', x, y, level.map.tileWidth, level.map.tileHeight)
end

function Pipe:update(dt)
  self.time = self.time - self.speed * dt       
  
  if self.time <= 0 and not self.filled then
    self.filled = true
    flowToPipe() 
  end
  
  --print("przed animacja id "..self.id)
  self:animate()  
end

function Pipe:animate()
  if self.animationImages then
    local animationIndex = table.getn( self.animationImages ) - math.floor( math.abs( self.time ) / self.animThreshold )
    self.oldAnimationIndex = animationIndex; 
    if not self.filled then
      self.animation = self.animationImages[ animationIndex ]
    else
      self.animation = self.animationImages[ table.getn( self.animationImages ) - math.fmod( animationIndex, 2 ) - 1 ]
    end    
  end
  --print("generic animate")
end

function Pipe:waterFrom(x, y)
  self.xWaterFrom = x
  self.yWaterFrom = y
  self.time = level.pipeTime
  self.speed = level.waterSpeed
end

function Pipe:getDebugString()
  xOff, yOff = self:getOffsetForNextPipe()
  return string.format("x[%d] y[%d] next x[%d] y[%d]", self.x, self.y, self.x + xOff, self.y + yOff)
end


HorizontalPipe = class( Pipe )
function HorizontalPipe:init(id)
  Pipe.init(self, id)
  self.animationImages = level.map.horizontalPipeImageAnim
  self.animThreshold = math.floor( level.pipeTime / ( table.getn( self.animationImages ) - 1 ) )  
end

function HorizontalPipe:getOffsetForNextPipe()
 return self.xWaterFrom, 0
end

function HorizontalPipe:acceptWaterFrom(x, y)
  return y == 0
end

function HorizontalPipe:drawPipe(x, y)  
  love.graphics.draw(level.map.horizontalPipeImage, x, y)
  if self.animation then    
    love.graphics.draw(self.animation, x, y)
  end
  --[[love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', x, y, level.map.tileWidth, level.map.tileHeight)
  love.graphics.setColor( {0, 0, 0} )
  love.graphics.line(x, y + (level.map.tileHeight / 2), x + level.map.tileWidth , y + (level.map.tileHeight / 2) )]]--
end


VerticalPipe = class( Pipe )
function VerticalPipe:init(id)
  Pipe.init(self, id)
  self.animationImages = level.map.verticalPipeImageAnim
  self.animThreshold = math.floor( level.pipeTime / ( table.getn( self.animationImages ) - 1 ) )  
end

function VerticalPipe:acceptWaterFrom(x, y)
  return x == 0
end

function VerticalPipe:getOffsetForNextPipe()
 return 0, self.yWaterFrom
end

function VerticalPipe:drawPipe(x, y)
  --love.graphics.setColor({ 100, 100, 100 })
  love.graphics.draw(level.map.verticalPipeImage, x, y)
  if self.animation then    
    love.graphics.draw(self.animation, x, y)
  end
  --[[love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', x, y, level.map.tileWidth, level.map.tileHeight)
  love.graphics.setColor( {0, 0, 0} )
  love.graphics.line(x + (level.map.tileWidth / 2), y, x + (level.map.tileWidth / 2) , y + level.map.tileHeight )]]--
end

CrossPipe = class( Pipe )

function CrossPipe:acceptWaterFrom(x, y)
  return true
end

function CrossPipe:drawPipe(x, y)
  love.graphics.draw(level.map.crossPipeImage, x, y)
  --[[love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', x, y, level.map.tileWidth, level.map.tileHeight)
  love.graphics.setColor( {0, 0, 0} )
  love.graphics.line(x + (level.map.tileWidth / 2), y, x + (level.map.tileWidth / 2) , y + level.map.tileHeight )
  love.graphics.line(x, y + (level.map.tileHeight / 2), x + level.map.tileWidth , y + (level.map.tileHeight / 2) )]]--
end

function CrossPipe:getOffsetForNextPipe()
 return self.xWaterFrom, self.yWaterFrom
end

AngleLeftUpPipe = class( Pipe )

function AngleLeftUpPipe:acceptWaterFrom(x, y)
  return x == 1 or y == 1
end

function AngleLeftUpPipe:getOffsetForNextPipe()
 if self.xWaterFrom == 1 then
  return 0, -1
 end 
 return -1, 0
end

function AngleLeftUpPipe:drawPipe(x, y)
  
  love.graphics.draw(level.map.leftUpPipeImage, x, y)
  --[[love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', x, y, level.map.tileWidth, level.map.tileHeight)
  love.graphics.setColor( {0, 0, 0} )
  love.graphics.line(x, y + (level.map.tileHeight / 2), x + (level.map.tileWidth / 2) , y + (level.map.tileHeight / 2), x + (level.map.tileWidth / 2), y )]]--
end


AngleLeftDownPipe = class( Pipe )

function AngleLeftDownPipe:acceptWaterFrom(x, y)
  return x == 1 or y == -1
end

function AngleLeftDownPipe:getOffsetForNextPipe()
 if self.xWaterFrom == 1 then
  return 0, 1
 end 
 return -1, 0
end

function AngleLeftDownPipe:drawPipe(x, y)
  
  love.graphics.draw(level.map.leftDownPipeImage, x, y)
  --[[love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', x, y, level.map.tileWidth, level.map.tileHeight)
  love.graphics.setColor( {0, 0, 0} )
  love.graphics.line(x, y + (level.map.tileHeight / 2), x + (level.map.tileWidth / 2) , y + (level.map.tileHeight / 2), x + (level.map.tileWidth / 2), y + level.map.tileHeight )]]--
end


AngleUpRightPipe = class( Pipe )

function AngleUpRightPipe:acceptWaterFrom(x, y)
  return x == -1 or y == 1
end

function AngleUpRightPipe:getOffsetForNextPipe()
 if self.xWaterFrom == -1 then
  return 0, -1
 end 
 return 1, 0
end

function AngleUpRightPipe:drawPipe(x, y)
  
  love.graphics.draw(level.map.upRightPipeImage, x, y)
  --[[love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', x, y, level.map.tileWidth, level.map.tileHeight)
  love.graphics.setColor( {0, 0, 0} )
  love.graphics.line(x + (level.map.tileWidth / 2), y, x + (level.map.tileWidth / 2) , y + (level.map.tileHeight / 2), x + level.map.tileWidth, y  + (level.map.tileHeight / 2) )]]--
end


AngleDownRightPipe = class( Pipe )
function AngleDownRightPipe:init(id)
  Pipe.init(self, id)
  self.animationImages = level.map.downRightPipeImageAnim
  self.animThreshold = math.floor( level.pipeTime / ( table.getn( self.animationImages ) - 1 ) )  
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

function AngleDownRightPipe:drawPipe(x, y)
  
  love.graphics.draw(level.map.downRightPipeImage, x, y)
  if self.animation then    
    love.graphics.draw(self.animation, x, y)
  end
  --[[love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', x, y, level.map.tileWidth, level.map.tileHeight)
  love.graphics.setColor( {0, 0, 0} )
  love.graphics.line(x + (level.map.tileWidth / 2), y + level.map.tileHeight, x + (level.map.tileWidth / 2) , y + (level.map.tileHeight / 2), x + level.map.tileWidth, y  + (level.map.tileHeight / 2) )]]--
end


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

