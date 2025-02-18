import 'CoreLibs/object'
import 'CoreLibs/sprites'
import 'CoreLibs/graphics'

local graphics = playdate.graphics
local sprite = graphics.sprite

local BLACK = graphics.kColorBlack
local CENTER = kTextAlignment.center
local BOLD = graphics.font.kVariantBold
local font = graphics.getFont(BOLD)

class('Label').extends(sprite)

function Label:init(label, x, y)
  Label.super.init(self)
  self.label = label
  self.x = x
  self.y = y
  self.mounted = false
end

function Label:add()
  Label.super:add()
  self.mounted = true
  graphics.setColor(BLACK)
  font:drawTextAligned(self.label, 20, 20, CENTER)
end

function Label:remove()
  self.mounted = false
end

function Label:update()
  print('Sprite update...')
end