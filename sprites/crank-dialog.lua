import 'CoreLibs/object'
import 'sprites/image-dialog'

local graphics = playdate.graphics
local image = graphics.image

local img = image.new('assets/crank-dialog')

class('CrankDialog').extends(ImageDialog)

function CrankDialog:init()
  CrankDialog.super.init(self, img)
end