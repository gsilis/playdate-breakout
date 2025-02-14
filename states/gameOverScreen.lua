import 'CoreLibs/object'
import 'states/screen'

class('GameOverScreen').extends(Screen)

local WIDTH = 400
local HALF_WIDTH = WIDTH / 2
local HEIGHT = 240
local HALF_HEIGHT = HEIGHT / 2
local graphics = playdate.graphics
local BOLD = graphics.font.kVariantBold
local font = graphics.getFont(BOLD)
local BLACK = graphics.kColorBlack
local WHITE = graphics.kColorWhite
local CENTER = kTextAlignment.center
local LEFT = kTextAlignment.left

function GameOverScreen:AButtonUp()
  self.setState(GAME_STATE)
end

function GameOverScreen:draw()
  graphics.clear()
  graphics.setLineWidth(3)
  graphics.setColor(BLACK)
  graphics.drawRect(HALF_WIDTH - 80, HALF_HEIGHT + 50, 160, 24)
  graphics.setColor(WHITE)
  font:drawTextAligned('GAME OVER', HALF_WIDTH - 60, HALF_HEIGHT + 53, LEFT)
end