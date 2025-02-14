import 'CoreLibs/object'
import 'CoreLibs/sprites'

local graphics = playdate.graphics
local sprite = graphics.sprite

class('GameWinScreen').extends(sprite)

function GameWinScreen:init(setState)
  GameWinScreen.super.init(self, setState)
end

function GameWinScreen:AButtonUp()
  self.setState(GAME_STATE)
end