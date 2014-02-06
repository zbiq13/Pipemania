require('util/class')

Enemy = class()
function Enemy:init()
  self.point = Point({ x = 'random', y = 'random' }, level.map.xSize, level.map.ySize)
  self.animationImages = level.map.enemyImageAnim  
  self.animationFramesNo = table.getn(self.animationImages)
  self.imageIndex = math.random(1, self.animationFramesNo)
  self.image = self.animationImages[ self.imageIndex ]
  
  self.blink = blinkRate
end

function Enemy:draw()
  self.point:drawWithImage(self.image)
end

function Enemy:acceptWaterFrom(x, y)
  return false
end

function Enemy:update(dt)
    self.blink = self.blink - dt * blinkSpeed
    if self.blink < 0 then
      self.blink = blinkRate
      self.imageIndex = math.fmod(self.imageIndex, self.animationFramesNo) + 1
      self.image = self.animationImages[ self.imageIndex ] 
    end 
end