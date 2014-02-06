require('util/class')


Goal = class()
function Goal:init()
  self.achieved = false;
end

--------------------------------
EndPointGoal = class( Goal )
function EndPointGoal:init()
  Goal.init(self)
end

function EndPointGoal:draw(x, y)
  love.graphics.setColor({ 255, 128, 0 })
  if self.achieved then
    love.graphics.setColor({ 45, 252, 7 })
  end
    
  love.graphics.printf("connect to end point", x, y, 150,"right")
end

--------------------------------
LampsGoal = class( Goal )
function LampsGoal:init(lampsNo)
  Goal.init(self)
  self.lampsNo = lampsNo
  self.lampsLighted = 0
end


function LampsGoal:lampLighted()
  self.lampsLighted = self.lampsLighted + 1;
  if self.lampsLighted == self.lampsNo then
    self.achieved = true;
  end
end

function LampsGoal:draw(x, y)
  love.graphics.setColor({ 255, 128, 0 })
  if self.achieved then
    love.graphics.setColor({ 45, 252, 7 })
  end
    
  local lampsInfo = string.format("connect lamps: %d/%d", self.lampsLighted, self.lampsNo)
  love.graphics.printf(lampsInfo, x, y, 150,"right")
end
