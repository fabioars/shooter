input = {
  left = false,
  right = false,
  fire = false,
  reset = false,
  exit = false
}
function handleInput()
  -- Input
  input.exit = love.keyboard.isDown('escape')
  -- Restart
  input.reset = not isAlive and love.keyboard.isDown('r')

  input.left = love.keyboard.isDown('left', 'a')
  input.right = love.keyboard.isDown('right', 'd') 
  input.fire = love.keyboard.isDown('space', 'rctrl', 'lctrl') and canShoot
end

function handleMouse()
  if love.mouse.isDown(1) then
    mouseRect = {
      x = love.mouse.getX() - 5,
      y = love.mouse.getY() - 5,
      w = 10,
      h = 10
    }

    -- Input
    input.exit = CheckCollision(mouseRect, exitUI.rect)

    -- Restart
    input.reset = not isAlive and CheckCollision(mouseRect, restartUI.rect)

    input.left = CheckCollision(mouseRect, leftUI.rect)
    input.right = CheckCollision(mouseRect, rightUI.rect)

    input.fire = CheckCollision(mouseRect, shootUI.rect) and canShoot
  end
end

function handleTouch()
  touches = love.touch.getTouches()
  for i, id in ipairs(touches) do
    x, y = love.touch.getPosition(id)
    touchRect = {
      x = x - 5,
      y = y - 5,
      w = 10,
      h = 10
    }

    -- Input
    input.exit = CheckCollision(touchRect, exitUI.rect)

    -- Restart
    input.reset = not isAlive and CheckCollision(touchRect, restartUI.rect)

    input.left = CheckCollision(touchRect, leftUI.rect)
    input.right = CheckCollision(touchRect, rightUI.rect)

    input.fire = CheckCollision(touchRect, shootUI.rect) and canShoot
  end
end

function inputReset()
  input = {
    left = false,
    right = false,
    fire = false,
    reset = false,
    exit = false
  }
end