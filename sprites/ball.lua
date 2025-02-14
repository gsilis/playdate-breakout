import 'CoreLibs/object'
import 'CoreLibs/sprites'

local graphics = playdate.graphics
local sprite = graphics.sprite
local image = graphics.image

local ballImage = image.new('assets/ball')

class('Ball').extends(sprite)

function Ball:init(x, y, speedX, speedY, scene)
  Ball.super.init(self)
  self.speedX = speedX
  self.speedY = speedY
  self:moveTo(x, y)
  self:setImage(ballImage)
  self:setCollideRect(0, 0, 12, 12)
  self.scene = scene
end

function Ball:tick()
  x, y = self:getPosition()

  local goalx = x + self.speedX
  local goaly = y + self.speedY

  actualx, actualy, collisions = self:moveWithCollisions(goalx, goaly)

  for _, collision in pairs(collisions) do
    local other = collision.other
    local name = other.name

    if name == 'BLOCK' or name == 'PADDLE' then
      if name == 'BLOCK' then
        self.scene:scorePoint(other)
      end

      if name == 'PADDLE' then
        self.speedX = self.scene:getNewSpeed(self.speedX)
      end
      
      if goalx ~= actualx then
        self.speedX = self.speedX * -1
      end

      if goaly ~= actualy then
        self.speedY = self.speedY * -1
      end
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