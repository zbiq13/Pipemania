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


--------------------------------
CircleGoal = class( Goal )
function CircleGoal:init(circlesNo)
  Goal.init(self)
  self.circlesNo = circlesNo
  self.cirlcesDone = 0
end


function CircleGoal:circleDone()
  self.cirlcesDone = self.cirlcesDone + 1;
  if self.cirlcesDone == self.circlesNo then
    self.achieved = true;
  end
end

function CircleGoal:draw(x, y)
  love.graphics.setColor({ 255, 128, 0 })
  if self.achieved then
    love.graphics.setColor({ 45, 252, 7 })
  end
    
  local circleInfo = string.format("make circles: %d/%d", self.cirlcesDone, self.circlesNo)
  love.graphics.printf(circleInfo, x, y, 150,"right")
end
