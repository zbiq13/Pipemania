require('util/class')

Pipe = class(Updatable)
function Pipe:init()
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
end

function Pipe:use( x, y )
  self.x = x
  self.y = y 
end

function Pipe:draw()
  self:drawPipe( self.x * level.map.tileWidth, self.y * level.map.tileHeight )
end

function Pipe:drawAsAvailable(index)
  self:drawPipe( 0, level.map.tileHeight * ( 5 - index ) )
  end

function Pipe:drawPipe(x, y)
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', x, y, level.map.tileWidth, level.map.tileHeight)
end

function Pipe:update(dt)
  if self.time > 0 then
    self.time = self.time - self.speed * dt
    self:flipColor()    
  else
    self.color = self.waterColor
    flowToPipe(); 
  end 
end

function Pipe:flipColor()
  self.color = self.color1
  self.color1 = self.color2
  self.color2 = self.color
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

function HorizontalPipe:getOffsetForNextPipe()
 return self.xWaterFrom, 0
end

function HorizontalPipe:acceptWaterFrom(x, y)
  return y == 0
end

function HorizontalPipe:drawPipe(x, y)
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', x, y, level.map.tileWidth, level.map.tileHeight)
  love.graphics.setColor( {0, 0, 0} )
  love.graphics.line(x, y + (level.map.tileHeight / 2), x + level.map.tileWidth , y + (level.map.tileHeight / 2) )
end


VerticalPipe = class( Pipe )

function VerticalPipe:acceptWaterFrom(x, y)
  return x == 0
end

function VerticalPipe:getOffsetForNextPipe()
 return 0, self.yWaterFrom
end

function VerticalPipe:drawPipe(x, y)
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', x, y, level.map.tileWidth, level.map.tileHeight)
  love.graphics.setColor( {0, 0, 0} )
  love.graphics.line(x + (level.map.tileWidth / 2), y, x + (level.map.tileWidth / 2) , y + level.map.tileHeight )
end


CrossPipe = class( Pipe )

function CrossPipe:acceptWaterFrom(x, y)
  return true
end

function CrossPipe:drawPipe(x, y)
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', x, y, level.map.tileWidth, level.map.tileHeight)
  love.graphics.setColor( {0, 0, 0} )
  love.graphics.line(x + (level.map.tileWidth / 2), y, x + (level.map.tileWidth / 2) , y + level.map.tileHeight )
  love.graphics.line(x, y + (level.map.tileHeight / 2), x + level.map.tileWidth , y + (level.map.tileHeight / 2) )
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
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', x, y, level.map.tileWidth, level.map.tileHeight)
  love.graphics.setColor( {0, 0, 0} )
  love.graphics.line(x, y + (level.map.tileHeight / 2), x + (level.map.tileWidth / 2) , y + (level.map.tileHeight / 2), x + (level.map.tileWidth / 2), y )
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
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', x, y, level.map.tileWidth, level.map.tileHeight)
  love.graphics.setColor( {0, 0, 0} )
  love.graphics.line(x, y + (level.map.tileHeight / 2), x + (level.map.tileWidth / 2) , y + (level.map.tileHeight / 2), x + (level.map.tileWidth / 2), y + level.map.tileHeight )
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
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', x, y, level.map.tileWidth, level.map.tileHeight)
  love.graphics.setColor( {0, 0, 0} )
  love.graphics.line(x + (level.map.tileWidth / 2), y, x + (level.map.tileWidth / 2) , y + (level.map.tileHeight / 2), x + level.map.tileWidth, y  + (level.map.tileHeight / 2) )
end


AngleDownRightPipe = class( Pipe )

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
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', x, y, level.map.tileWidth, level.map.tileHeight)
  love.graphics.setColor( {0, 0, 0} )
  love.graphics.line(x + (level.map.tileWidth / 2), y + level.map.tileHeight, x + (level.map.tileWidth / 2) , y + (level.map.tileHeight / 2), x + level.map.tileWidth, y  + (level.map.tileHeight / 2) )
end

