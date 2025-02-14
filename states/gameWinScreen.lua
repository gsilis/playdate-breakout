import 'states/screen'
import 'CoreLibs/object'
import 'CoreLibs/sprites'

local graphics = playdate.graphics
local sprite = graphics.sprite

class('GameWinScreen').extends(Screen)

function GameWinScreen:init(setState)
  GameWinScreen.super:init(setState)
end

function GameWinScreen:AButtonUp()
  self.setState(GAME_STATE)
end