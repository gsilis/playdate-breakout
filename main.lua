import 'CoreLibs/frameTimer'
import 'CoreLibs/sprites'
import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'states/titleScreen'
import 'states/gameScreen'
import 'states/gameOverScreen'
import 'states/gameWinScreen'

TITLE_STATE = 'title'
GAME_STATE = 'game'
GAME_WIN_STATE = 'game_win'

local graphics = playdate.graphics
local sprite = graphics.sprite
local updateFrameTimers = playdate.frameTimer.updateTimers
local gameState = TITLE_STATE
local states = {}

function setState(newStateName)
  local oldState = states[gameState]
  local newState = states[newStateName]

  oldState:pause()
  gameState = newStateName

  if newStateName == GAME_STATE then
    newState:reset()
  end

  newState:resume()
end

states[TITLE_STATE] = TitleScreen(setState)
states[GAME_STATE] = GameScreen(setState)
states[GAME_WIN_STATE] = GameWinScreen(setState)

function currentState()
  return states[gameState]
end

function playdate.update()
  sprite:update()
  currentState():draw()
  updateFrameTimers()
end

local stateFunctions = {
  'AButtonDown',
  'AButtonUp',
  'AButtonHeld',
  'BButtonDown',
  'BButtonUp',
  'BButtonHeld',
  'cranked',
  'crankDocked',
  'crankUndocked',
  'draw'
}

for _, fn in ipairs(stateFunctions) do
  playdate[fn] = function(a, b, c)
    local state = currentState()
    state[fn](state, a, b, c)
  end
end