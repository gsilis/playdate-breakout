import 'CoreLibs/object'
import 'CoreLibs/sprites'

local graphics = playdate.graphics
local sprite = graphics.sprite
local image = graphics.image

local ballImage = image.new('assets/ball')

class('ImprovedBall').extends(sprite)

function ImprovedBall:init(x, y)
  ImprovedBall.super.init(self)

  self.xspeed = 0
  self.yspeed = 0

  self:moveTo(x, y)
  self:setImage(ballImage)
  self:setCollideRect(0, 0, 12, 12)
end

function ImprovedBall:setSpeed(x, y)
  self.xspeed = x
  self.yspeed = y
end

function ImprovedBall:tick()
  local x, y = self:getPosition()
  local xgoal = x + self.xspeed
  local ygoal = y + self.yspeed
  local xactual, yactual, collisions = self:moveWithCollisions(xgoal, ygoal)
  local collision = collisions[1]

  if not collision then
    return
  end

  local collider = collision.other
  local colliderName = collider.name

  if colliderName == 'LEFT' or colliderName == 'RIGHT' then
    self:setSpeed(self.xspeed * -1, self.yspeed)
  elseif colliderName == 'TOP' then
    self:setSpeed(self.xspeed, self.yspeed * -1)
  elseif colliderName == 'PADDLE' then
    if xactual ~= xgoal then
      self:setSpeed(self.xspeed * -1, self.yspeed)
    end

    if yactual ~= ygoal then
      self:setSpeed(self.xspeed, self.yspeed * -1)
    end

    local xnew, ynew = collider:getSpeed(self.xspeed, self.yspeed)

    self:setSpeed(xnew, ynew)
  elseif colliderName == 'BLOCK' then
    if xactual ~= xgoal then
      self:setSpeed(self.xspeed * -1, self.yspeed)
    end

    if yactual ~= ygoal then
      self:setSpeed(self.xspeed, self.yspeed * -1)
    end

    collider:remove()
  end
end

function ImprovedBall:collisionResponse(other)
  if other and other.name == 'BOTTOM' then
    return sprite.kCollisionTypeFreeze
  else
    return sprite.kCollisionTypeBounce
  end
end