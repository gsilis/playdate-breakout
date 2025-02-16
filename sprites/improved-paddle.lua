import 'CoreLibs/object'
import 'CoreLibs/sprites'
import 'utilities/bounce-calculator'

local graphics = playdate.graphics
local sprite = graphics.sprite
local image = graphics.image

local moveMax = 20
local oneThird = moveMax / 3
local twoThird = oneThird * 2
local paddleImage = image.new('assets/paddle')

class('ImprovedPaddle').extends(sprite)

function ImprovedPaddle:init(x, y)
  ImprovedPaddle.super.init(self)
  self.bounceCalculator = BounceCalculator(3, 1)
  self.lastMovement = 0
  self.x = x
  self.y = y
  self.name = 'PADDLE'

  self:setImage(paddleImage)
  self:moveTo(x, y)
  self:setCollideRect(0, 16, 32, 8)
end

function ImprovedPaddle:tick()
  self.bounceCalculator:decreaseBy(1)
end

function ImprovedPaddle:moveBy(xdiff)
  local multiplier = xdiff / math.abs(xdiff)

  -- Make sure the diff is within bounds
  -- Diff cannot be below min
  if math.abs(xdiff) > moveMax then
    xdiff = moveMax * multiplier
  end

  local absDiff = math.abs(xdiff)
  local absLastDiff = math.abs(self.lastMovement)
  local moreIntense = absDiff > absLastDiff
  local xnew = self.x + xdiff
  local direction = xnew - self.x

  if direction < 0 then
    direction = -1
  elseif direction > 0 then
    direction = 1
  end

  self.bounceCalculator:setDirection(direction)

  if moreIntense then
    if absDiff > twoThird then
      self.bounceCalculator:increaseBy(2)
    elseif absDiff > oneThird then
      self.bounceCalculator:increaseBy(1)
    end
  else
    self.bounceCalculator:decreaseBy(1)
  end

  self.x = xnew
  actualx, actualy, collisions = self:moveWithCollisions(self.x, self.y)
end

function ImprovedPaddle:getSpeed(x, y)
  return self.bounceCalculator:calculateSpeed(x, y)
end

function ImprovedPaddle:collisionResponse()
  return sprite.kCollisionTypeFreeze
end