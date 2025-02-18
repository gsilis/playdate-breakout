import 'CoreLibs/object'
import 'sprites/image-dialog'

local graphics = playdate.graphics
local image = graphics.image

local img = image.new('assets/game-over-dialog')

class('GameOverDialog').extends(ImageDialog)

function GameOverDialog:init()
  GameOverDialog.super.init(self, img)
end