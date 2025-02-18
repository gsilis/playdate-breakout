import 'CoreLibs/object'

local graphics = playdate.graphics
local sprite = graphics.sprite

class('ImageDialog').extends(sprite)

function ImageDialog:init(image)
  ImageDialog.super.init(self)

  self.image = sprite.new(image)

  local hw = self.image.width / 2
  local hh = self.image.height / 2

  self.image:moveTo(hw, hh)
end

function ImageDialog:add()
  self.image:add()
end

function ImageDialog:remove()
  self.image:remove()
end