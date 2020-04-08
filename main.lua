debug = true

-- Inputs
input = {
  left = false,
  right = false,
  fire = false,
  reset = false,
  exit = false
}

-- Screen center
screenCenter = { x = 0, y = 0 }

-- World Bounds
bounds = { left = 0, right = 0}

-- Player
player = {
  x = 200,
  y = 710,
  speed = 150,
  img = nil
}

-- Player Bullets
bulletImg = nil
bulletAudio = nil
bullets = {}

-- Shoot timer
canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

-- Enemy Spawn Timers
createEnemyTimerMax = 0.4
createEnemyTimer = createEnemyTimerMax

-- Enemy
enemyImg = nil
enemies = {}

-- Live And Score
isAlive = true
score = 0

-- UI
leftUI = { img = nil, x = 0, y = 0, rect = nil }
rightUI = { img = nil, x = 0, y = 0, rect = nil }
shootUI = { img = nil, x = 0, y = 0, rect = nil }
exitUI = { img = nil, x = 0, y = 0, rect = nil }
restartUI = { img = nil, x = 0, y = 0, rect = nil }

function love.load(arg)
  
  -- Load player
  player.img = love.graphics.newImage('assets/plane.png')
  -- Load bullet
  bulletImg = love.graphics.newImage('assets/bullet.png')
  bolletAudio = love.audio.newSource('assets/gun-sound.wav', 'stream')
  -- Load Enemy
  enemyImg = love.graphics.newImage('assets/enemy.png')
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

  -- Calculate Word bounds
  bounds.right = (love.graphics.getWidth() - player.img:getWidth())
  -- Calculate Screen center
  screenCenter.x = love.graphics:getWidth() / 2
  screenCenter.y = love.graphics:getHeight() / 2

  resetGame()
end

function love.update(dt)
  input = {
    left = false,
    right = false,
    fire = false,
    reset = false,
    exit = false
  }

  handleInput()
  handleMouse()
  handleTouch()

  if input.exit then
    love.event.push('quit')
  end

  if input.reset then
    resetGame()
  end

  -- Enemy Spawn timer
  createEnemyTimer = createEnemyTimer - (1 * dt)
  if createEnemyTimer < 0 then
    createEnemyTimer = createEnemyTimerMax

    randomXPosition = math.random(10, love.graphics.getWidth() - 10)
    newEnemy = { x = randomXPosition, y = -10, img = enemyImg }
    table.insert(enemies, newEnemy)
  end
  -- Enemy AI
  for i, enemy in ipairs(enemies) do
    enemy.y = enemy.y + (200 * dt)
    
    if enemy.y > 850 then
      table.remove(enemies, i)
    end
  end

  -- Shoot timer
  canShootTimer = canShootTimer - (1 * dt)
  if(canShootTimer < 0) then
    canShoot = true
  end

  -- Shoot
  if input.fire and isAlive then
    newBullet = {
      x = player.x + (player.img:getWidth()/2) - 5,
      y = player.y,
      img = bulletImg
    }

    table.insert(bullets, newBullet)
    love.audio.play(bolletAudio)
    canShoot = false
    canShootTimer = canShootTimerMax
  end
  -- Bullet moviment
  for i, bullet in ipairs(bullets) do
    bullet.y = bullet.y - (250 * dt)

    if bullet.y < 0 then
      table.remove(bullets, i)
    end
  end

  -- Player moviment
  speed = (player.speed * dt)
  if input.left then
    if player.x > bounds.left then
      player.x = player.x - speed
    end
  elseif input.right then
    if player.x < bounds.right then
      player.x = player.x + speed
    end
  end

  -- Detection
  for i, enemy in ipairs(enemies) do
    enemyRect = createRect(enemy, enemyImg)
    for j, bullet in ipairs(bullets) do
      bulletRect = createRect(bullet, bulletImg)

      if CheckCollision(enemyRect, bulletRect) then
        table.remove(bullets, j)
        table.remove(enemies, i)
        score = score + 1
      end
    end

    playerRect = createRect(player, player.img)
    if CheckCollision(enemyRect, playerRect) and isAlive then
      table.remove(enemies, i)
      isAlive = false
    end
  end
end

function love.draw(dt)
  if isAlive then
    love.graphics.draw(player.img, player.x, player.y)
    love.graphics.draw(leftUI.img, leftUI.x, leftUI.y)
    love.graphics.draw(rightUI.img, rightUI.x, rightUI.y)
    love.graphics.draw(shootUI.img, shootUI.x, shootUI.y)
  else
    love.graphics.print("Game Over", screenCenter.x - 35, screenCenter.y - 10)
    love.graphics.draw(restartUI.img, restartUI.x, restartUI.y)
  end

  for i, bullet in ipairs(bullets) do
    love.graphics.draw(bulletImg, bullet.x, bullet.y)
  end

  for i, enemy in ipairs(enemies) do
    love.graphics.draw(enemy.img, enemy.x, enemy.y)
  end

  love.graphics.print("SCORE", 10, 10)
  love.graphics.print(score, 10, 32)

  love.graphics.draw(exitUI.img, exitUI.x, exitUI.y)
end

function resetGame()
  bullets = {}
  enemies = {}
  canShootTimer = canShootTimerMax
  createEnemyTimer = createEnemyTimerMax

  player.x = screenCenter.x - player.img:getWidth() / 2
  player.y = love.graphics:getHeight() - player.img:getHeight() - 10

  score = 0
  isAlive = true
end

function CheckCollision(rect1, rect2)
  return rect1.x < rect2.x + rect2.w and
         rect2.x < rect1.x + rect1.w and
         rect1.y < rect2.y + rect2.h and
         rect2.y < rect1.y + rect1.h
end

function createRect(element, img)
  return {
    x = element.x,
    y = element.y,
    w = img:getWidth(),
    h = img:getHeight()
  }
end

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
