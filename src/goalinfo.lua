require('util/class')

function printGoalInfo() 
  
  local x = width - 80
  local yIndex = 0
  local yRate = 60
  
  
  love.graphics.reset()
  love.graphics.draw(goalsImage, width - 105, 10, 0, 0.8, 0.8)
  
  yIndex = printGoalInfoImage(level.map.startImage, x, yRate, yIndex)
  
  for i, lamp in next, level.lamps, nil do
    if lamp.lighted then
      yIndex = printGoalInfoImage(arrowGreenImage, x, yRate, yIndex)
    else
      yIndex = printGoalInfoImage(arrowRedImage, x, yRate, yIndex)   
    end
    yIndex = printGoalInfoImage(level.map.lampImage, x, yRate, yIndex)
  end
  
  for i = 0, level.circleGoal.circlesNo-1 do
    if i < level.circleGoal.circlesDone then
      yIndex = printGoalInfoImage(arrowGreenImage, x, yRate, yIndex)
    else
      yIndex = printGoalInfoImage(arrowRedImage, x, yRate, yIndex)   
    end
    yIndex = printGoalInfoImage(level.map.crossPipeImage, x, yRate, yIndex)
  end
  
  yIndex = printGoalInfoImage(arrowRedImage, x, yRate, yIndex)
  yIndex = printGoalInfoImage(level.map.endImage, x, yRate, yIndex)
  
  --[[ local y = 100;
  for i,goal in next,level.goals,nil do
    goal:draw(width - 200, i * y)
  end ]]--
  --[[love.graphics.printf("connect to end point", width - 200, 20, 150,"right")
  
  local lampsSize = table.getn(level.lamps)
  if lampsSize > 0 then
    
    local lampsInfo = string.format("connect lamps: %d/%d", level.lampsLighted, lampsSize)
    love.graphics.printf(lampsInfo, width - 200, 40, 150,"right")
  end]]--
end

function printGoalInfoImage(image, x, yRate, yIndex)
  love.graphics.draw(image, x, 50 + yRate * yIndex, 0, 0.7, 0.7)
  return yIndex + 1  
end