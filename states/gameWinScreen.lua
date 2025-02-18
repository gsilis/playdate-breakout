import 'states/screen'
import 'CoreLibs/object'
import 'CoreLibs/sprites'
import 'sprites/game-win-dialog'

class('GameWinScreen').extends(Screen)

function GameWinScreen:init(setState)
  GameWinScreen.super:init(setState)
  self.dialog = GameWinDialog()
end

function GameWinScreen:pause()
  self.dialog:remove()
end

function GameWinScreen:resume()
  self.dialog:add()
end

function GameWinScreen:AButtonUp()
  self.setState(GAME_STATE)
end