require 'ui'
require 'input'
require 'collision'

debug = true

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

function love.load(arg)
  -- Load player
  player.img = love.graphics.newImage('assets/plane.png')
  -- Load bullet
  bulletImg = love.graphics.newImage('assets/bullet.png')
  bolletAudio = love.audio.newSource('assets/gun-sound.wav', 'stream')
  -- Load Enemy
  enemyImg = love.graphics.newImage('assets/enemy.png')

  uiload()

  -- Calculate Word bounds
  bounds.right = (love.graphics.getWidth() - player.img:getWidth())
  -- Calculate Screen center
  screenCenter.x = love.graphics:getWidth() / 2
  screenCenter.y = love.graphics:getHeight() / 2

  resetGame()
end

function love.update(dt)
  inputReset()
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
  end

  for i, bullet in ipairs(bullets) do
    love.graphics.draw(bulletImg, bullet.x, bullet.y)
  end

  for i, enemy in ipairs(enemies) do
    love.graphics.draw(enemy.img, enemy.x, enemy.y)
  end

  uidraw(isAlive)
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
