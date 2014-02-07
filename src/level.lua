require('util/class')
require('point')
require('lamp')
require('goal')
require('enemy')


Level = class()
function Level:init(levelDesc)
  self.map = 
  {
    xSize = levelDesc.xSize,
    ySize = levelDesc.ySize,
    tileWidth = 80,
    tileHeight = 80,
    tileImage = levelDesc.tileImage,
    startImage = levelDesc.startImage,
    endImage = levelDesc.endImage,    
    backgroundImage = levelDesc.backgroundImage,
    verticalPipeImage = levelDesc.verticalPipeImage,
    horizontalPipeImage = levelDesc.horizontalPipeImage,
    crossPipeImage = levelDesc.crossPipeImage,
    leftUpPipeImage = levelDesc.leftUpPipeImage,
    leftDownPipeImage = levelDesc.leftDownPipeImage,
    upRightPipeImage = levelDesc.upRightPipeImage,
    downRightPipeImage = levelDesc.downRightPipeImage,
    
    verticalPipeImageAnim = levelDesc.verticalPipeImageAnim,
    horizontalPipeImageAnim = levelDesc.horizontalPipeImageAnim,
    downRightPipeImageAnim = levelDesc.downRightPipeImageAnim,
    
    lampImage = levelDesc.lampImage,
    lampImageAnim = levelDesc.lampImageAnim,
    
    enemiesNo = levelDesc.enemiesNo,
    enemyImageAnim = levelDesc.enemyImageAnim
  }
  
  self.startPoint = Point(levelDesc.startPoint, self.map.xSize, self.map.ySize)
  repeat 
    self.endPoint = Point(levelDesc.endPoint, self.map.xSize, self.map.ySize)
  until ( levelDesc.endPoint.x ~= 'random' or math.fmod( math.abs( self.endPoint.x - self.startPoint.x ), self.map.xSize ) > 2 ) and
    ( levelDesc.endPoint.y ~= 'random' or math.fmod( math.abs( self.endPoint.y - self.startPoint.y ), self.map.ySize ) > 2 )
  
  self.lamps = {}
  for i, lampDesc in next, levelDesc.lamps, nil do
    table.insert(self.lamps, Lamp(lampDesc))
  end 
  
  self.enemies = {}
  for i = 1, self.map.enemiesNo do
    table.insert(self.enemies, Enemy())
  end 
  
  self.startColor = { 0, 0, 0 }
  self.pipeTime = levelDesc.pipeTime
  self.waterSpeed = levelDesc.waterSpeed
  self.initialTime = levelDesc.initialTime
  
  self.lampsLighted = 0
  
  self.pipeSeq = 0
  
  --goals
  self.goals = {}
  self.endPointGoal = EndPointGoal()
  self.lampsGoal = LampsGoal(table.getn(self.lamps))  
  self.circleGoal = CircleGoal(levelDesc.circlesNo)  
  
  table.insert( self.goals, self.endPointGoal )  
  
  if self.lampsGoal.lampsNo > 0 then
    table.insert( self.goals, self.lampsGoal )
  end
    
  if self.circleGoal.circlesNo > 0 then
    table.insert( self.goals, self.circleGoal )
  end
end


function Level:canPassWallAt(x, y)
  return true
end


function Level:endPointReached()
  self.endPointGoal.achieved = true  
end


function Level:checkResult()
  local goalsAchieved = true
  
  for i, goal in next,self.goals,nil do
    goalsAchieved = goalsAchieved and goal.achieved
  end 
  
  if goalsAchieved then
    levelWon()
  else
    gameLost()
  end
end


function Level:draw()
  
  love.graphics.reset()
  love.graphics.draw(self.map.backgroundImage, x, y)
  
  self.startPoint:drawWithImage(self.map.startImage)
  self.endPoint:drawWithImage(self.map.endImage)
  
  for i, lamp in next,self.lamps,nil do
    lamp:draw()
  end 
  
  for i, enemy in next,self.enemies,nil do
    enemy:draw()
  end 
end