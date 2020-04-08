-- UI
leftUI = { img = nil, x = 0, y = 0, rect = nil }
rightUI = { img = nil, x = 0, y = 0, rect = nil }
shootUI = { img = nil, x = 0, y = 0, rect = nil }
exitUI = { img = nil, x = 0, y = 0, rect = nil }
restartUI = { img = nil, x = 0, y = 0, rect = nil }

function uiload()
  -- Load ui
  leftUI.img = love.graphics.newImage('assets/touch/left.png')
  leftUI.x = 20
  leftUI.y = love.graphics:getHeight() - leftUI.img:getHeight() - 20
  leftUI.rect = createRect(leftUI, leftUI.img)

  rightUI.img = love.graphics.newImage('assets/touch/right.png')
  rightUI.x = leftUI.x + leftUI.img:getWidth() + 20
  rightUI.y = leftUI.y
  rightUI.rect = createRect(rightUI, rightUI.img)

  shootUI.img = love.graphics.newImage('assets/touch/shoot.png')
  shootUI.x = love.graphics:getWidth() - leftUI.img:getWidth() - 20
  shootUI.y = leftUI.y
  shootUI.rect = createRect(shootUI, shootUI.img)

  exitUI.img = love.graphics.newImage('assets/touch/exit.png')
  exitUI.x = love.graphics:getWidth() - exitUI.img:getWidth() - 20
  exitUI.y = 20
  exitUI.rect = createRect(exitUI, exitUI.img)

  restartUI.img = love.graphics.newImage('assets/touch/restart.png')
  restartUI.x = (love.graphics:getWidth()/2) - (restartUI.img:getWidth()/2)
  restartUI.y = love.graphics:getHeight()/2 - (restartUI.img:getHeight()/2) + 50
  restartUI.rect = createRect(restartUI, restartUI.img)
end

function uidraw(isAlive)
  if isAlive then
    love.graphics.draw(leftUI.img, leftUI.x, leftUI.y)
    love.graphics.draw(rightUI.img, rightUI.x, rightUI.y)
    love.graphics.draw(shootUI.img, shootUI.x, shootUI.y)
  else
    love.graphics.print('Game Over', screenCenter.x - 35, screenCenter.y - 10)
    love.graphics.draw(restartUI.img, restartUI.x, restartUI.y)
  end

  love.graphics.print("SCORE", 10, 10)
  love.graphics.print(score, 10, 32)

  love.graphics.draw(exitUI.img, exitUI.x, exitUI.y)
end