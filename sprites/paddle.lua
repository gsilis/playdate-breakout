import 'CoreLibs/object'
import 'CoreLibs/sprites'

local graphics = playdate.graphics
local image = graphics.image
local sprite = graphics.sprite

local paddleImage = image.new('assets/paddle')

class('Paddle').extends(sprite)

function Paddle:init(x, y)
  Paddle.super.init(self)
  self:setImage(paddleImage)
  self:moveTo(x, y)
  self:setCollideRect(0, 16, 32, 8)
  self.name = 'PADDLE'
end

function Paddle:collisionResponse(collider)
  collider.speedY = collider.speedY * -1
  return sprite.kCollisionTypeFreeze
end