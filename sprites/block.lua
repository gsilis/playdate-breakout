import 'CoreLibs/object'
import 'CoreLibs/sprites'

local graphics = playdate.graphics
local sprite = graphics.sprite
local image = graphics.image

local block1 = image.new('assets/point-1')
local block2 = image.new('assets/point-2')
local block3 = image.new('assets/point-3')
local block4 = image.new('assets/point-4')
local blocks = {block1, block2, block3, block4}

class('Block').extends(sprite)

function Block:init(x, y, type)
  Block.super.init(self)
  self:moveTo(x, y)
  self:setType(type)
  self:setCollideRect(0, 0, 16, 8)
end

function Block:setType(type)
  self.type = type
  self:setImage(blocks[type])
end