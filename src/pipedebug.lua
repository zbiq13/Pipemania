
function printDebug()
  love.graphics.setFont(debugFont)
  love.graphics.printf(string.format("player at x[%d] y[%d]", player.x, player.y), 0, height - 80, width, "left")
  love.graphics.printf(string.format("timer: %d", updatable.time), 0, height - 60, width, "left")
  if updatable then
    love.graphics.printf(updatable:getDebugString(), 0, height - 40, width, "left")
  end
  if lost then
    love.graphics.printf("you lost", 0, height - 20, width, "left")
  elseif wonLevel then
    love.graphics.printf("you won", 0, height - 20, width, "left")
  end
end