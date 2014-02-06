require('util/class')

function printGoalInfo()
  love.graphics.setFont(debugFont)
  local y = 20;
  for i,goal in next,level.goals,nil do
    goal:draw(width - 200, i * y)
  end
  --[[love.graphics.printf("connect to end point", width - 200, 20, 150,"right")
  
  local lampsSize = table.getn(level.lamps)
  if lampsSize > 0 then
    
    local lampsInfo = string.format("connect lamps: %d/%d", level.lampsLighted, lampsSize)
    love.graphics.printf(lampsInfo, width - 200, 40, 150,"right")
  end]]--
end