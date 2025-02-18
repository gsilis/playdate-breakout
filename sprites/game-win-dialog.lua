import 'CoreLibs/object'
import 'sprites/image-dialog'

local graphics = playdate.graphics
local image = graphics.image

local img = image.new('assets/game-win-dialog')

class('GameWinDialog').extends(ImageDialog)

function GameWinDialog:init()
  GameWinDialog.super.init(self, img)
end