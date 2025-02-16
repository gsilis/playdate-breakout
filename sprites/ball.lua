import 'CoreLibs/object'
import 'CoreLibs/sprites'

local graphics = playdate.graphics
local sprite = graphics.sprite
local image = graphics.image

local ballImage = image.new('assets/ball')

class('Ball').extends(sprite)

function Ball:init(x, y, speedX, speedY, scene)
  Ball.super.init(self)
  self.moving = false
  self.xmultiplier = 1
  self.ymultiplier = 1
  self.speedX = speedX
  self.speedY = speedY
  self:moveTo(x, y)
  self:setImage(ballImage)
  self:setCollideRect(0, 0, 12, 12)
  self.scene = scene
end

function Ball:tick()
  if self.moving == false then
    return
  end

  x, y = self:getPosition()

  local goalx = x + self.speedX
  local goaly = y + self.speedY

  actualx, actualy, collisions = self:moveWithCollisions(goalx, goaly)

  local collision = collisions[1]

  if not collision then
    return
  end

  local other = collision.other
  local name = other.name

  if goalx ~= actualx then
    print('Goal x != actual x')
    self.xmultiplier = self.xmultiplier * -1
  end

  if goaly ~= actualy then
    print('Goal y != actual y')
    self.ymultiplier = self.ymultiplier * -1
  end

  if name == 'BLOCK' then
    self:setSpeed(self.speedX * self.xmultiplier, self.speedY * self.ymultiplier)
  elseif name == 'PADDLE' then
    -- self.speedX = self.scene:getNewSpeed(self.speedX)
    local x, y = other:getSpeed(self.speedX, self.speedY)
    self:setSpeed(x, y)

    print(self.speedX * self.xmultiplier, self.speedY * self.ymultiplier)
    self:setSpeed(self.speedX * self.xmultiplier, self.speedY * self.ymultiplier)
  elseif name == 'LEFT' then
    self.speedX = self.speedX * -1
  elseif name == 'RIGHT' then
    self.speedX = self.speedX * -1
  elseif name == 'TOP' then
    self.speedY = self.speedY * -1
  elseif name == 'BOTTOM' then
    self.scene:hitBottom()
  end
end

function Ball:setSpeed(speedX, speedY)
  self.speedX = speedX
  self.speedY = speedY
end

function Ball:collisionResponse(other)
  local name = other.name

  if name == 'BOTTOM' then
    return sprite.kCollisionTypeFreeze
  else
    return sprite.kCollisionTypeBounce
  end
end