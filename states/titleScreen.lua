import 'CoreLibs/graphics'
import 'CoreLibs/object'
import 'CoreLibs/animation'
import 'states/screen'
import 'sprites/crank-dialog'

local graphics = playdate.graphics
local image = graphics.image
local background = image.new('assets/splash')

class('TitleScreen').extends(Screen)

function TitleScreen:init(setState)
  TitleScreen.super.init(self, setState)
  self.playWhenUndocked = false
  self.crankDialog = CrankDialog()
end

function TitleScreen:AButtonUp()
  if playdate.isCrankDocked() then
    self.playWhenUndocked = true
    self.crankDialog:add()
  else
    self.setState(GAME_STATE)
  end
end

function TitleScreen:pause()
  self.playWhenUndocked = false
  self.crankDialog:remove()
end

function TitleScreen:crankUndocked()
  self.crankDialog:remove()

  if self.playWhenUndocked then
    self.setState(GAME_STATE)
  end
end

function TitleScreen:draw()
  if self.playWhenUndocked then
    return
  end

  graphics.clear()
  background:draw(0, 0)
end