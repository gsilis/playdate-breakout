import 'CoreLibs/graphics'
import 'CoreLibs/object'
import 'CoreLibs/animation'
import 'states/screen'

local graphics = playdate.graphics
local sprite = graphics.sprite
local image = graphics.image
local imagetable = graphics.imagetable
local animation = graphics.animation
local rect = playdate.geometry.rect

local WIDTH = 400
local HALF_WIDTH = WIDTH / 2
local HEIGHT = 240
local HALF_HEIGHT = HEIGHT / 2
local BOLD = graphics.font.kVariantBold
local font = graphics.getFont(BOLD)
local BLACK = graphics.kColorBlack
local WHITE = graphics.kColorWhite
local RIGHT = kTextAlignment.right
local LEFT = kTextAlignment.left

local crankFrames = imagetable.new('assets/crank')
local crankAnimation = animation.loop.new(400, crankFrames, true)
local crankMessageRect = rect.new(WIDTH - 100, HEIGHT - 140, 100, 40)
local background = image.new('assets/splash')

class('TitleScreen').extends(Screen)

function TitleScreen:init(setState)
  TitleScreen.super.init(self, setState)
  self.blink = 0
end

function TitleScreen:AButtonUp()
  if playdate.isCrankDocked() then
    self.blink = 20
  else
    self.setState(GAME_STATE)
  end
end

function TitleScreen:pause()
end

function TitleScreen:draw()
  graphics.clear()
  background:draw(0, 0)
  graphics.setColor(WHITE)
  font:drawTextAligned('Press A to start', 130, 205, LEFT)

  if playdate.isCrankDocked() then
    graphics.setColor(WHITE)
    graphics.fillRect(WIDTH - 110, HEIGHT - 150, 110, 150)
    graphics.setColor(BLACK)

    if self.blink == 0 or self.blink % 3 == 0 then
      font:drawTextAligned('Undock the crank to play', crankMessageRect, RIGHT)
    end

    if self.blink > 0 then
      self.blink = self.blink - 1
    end

    crankAnimation:draw(WIDTH - 100, HEIGHT - 100)
  end
end