import 'CoreLibs/object'
import 'CoreLibs/sprites'
import 'states/screen'
import 'sprites/improved-paddle'
import 'sprites/improved-ball'
import 'sprites/ball'
import 'sprites/block'
import 'sprites/game-over-dialog'

class('GameScreen').extends(Screen)

local graphics = playdate.graphics
local sprite = graphics.sprite
local image = graphics.image

local WIDTH = 400
local HALF_WIDTH = WIDTH / 2
local HEIGHT = 240
local HALF_HEIGHT = HEIGHT / 2
local initialPaddlePosition = HALF_WIDTH
local paddleY = HEIGHT - 30
local WHITE = graphics.kColorWhite
local ballRadius = 6
local rows = 8
local columns = 23
local columnOffset = 16
local columnWidth = 16
local rowOffset = 32
local rowHeight = 8

-- Variables used for drawing
local paddlePosition = initialPaddlePosition
local background = image.new('assets/background')

function respondWithBounce()
  return sprite.kCollisionTypeBounce
end

function respondWithOverlap()
  return sprite.kCollisionTypeOverlap
end

function GameScreen:init(setState)
  GameScreen.super:init(setState)

  self.playing = true
  self.moving = false
  self.paddle = ImprovedPaddle(paddlePosition, paddleY)
  self.ball = ImprovedBall(paddlePosition, paddleY, self)
  self.gameOverDialog = GameOverDialog()

  self.top = sprite.new()
  self.top:moveTo(0, -10)
  self.top:setCollideRect(0, 0, WIDTH, 10)
  self.top.name = 'TOP'

  self.left = sprite.new()
  self.left:moveTo(-10, 0)
  self.left:setCollideRect(0, 0, 10, HEIGHT)
  self.left.name = 'LEFT'

  self.right = sprite.new()
  self.right:moveTo(WIDTH, 0)
  self.right:setCollideRect(0, 0, 10, HEIGHT)
  self.right.name = 'RIGHT'

  self.bottom = sprite.new()
  self.bottom:moveTo(0, HEIGHT)
  self.bottom:setCollideRect(0, 0, WIDTH, 10)
  self.bottom.name = 'BOTTOM'

  self.points = {}
  self.scored = 0
  self:createPoints()

  self.background = sprite.new()
  self.background:moveTo(HALF_WIDTH, HALF_HEIGHT)
  self.background:setImage(background)
end

function GameScreen:AButtonUp()
  if self.playing == false then
    self.setState(GAME_STATE)
  elseif self.moving == false then
    self.moving = true
    self.ball:setSpeed(2, -2)
  end
end

function GameScreen:BButtonUp()
  self.moving = not self.moving

  if self.moving then
    local x, y = self.paddle:getSpeed(2, -2)
    self.ball:setSpeed(x, y)
  else
    self.ball:setSpeed(0, 0)
  end
end

function GameScreen:resume()
  self.background:add()
  self.paddle:add()
  self.ball:add()
  self.left:add()
  self.top:add()
  self.right:add()
  self.bottom:add()

  for _, point in pairs(self.points) do
    point:add()
  end
end

function GameScreen:pause()
  self.background:remove()
  self.paddle:remove()
  self.ball:remove()
  self.left:remove()
  self.top:remove()
  self.right:remove()
  self.bottom:remove()

  for _, point in pairs(self.points) do
    point:remove()
  end
end

function GameScreen:reset()
  self.scored = 0
  paddlePosition = initialPaddlePosition

  self.gameOverDialog:remove()
  self.paddle:moveBy(paddlePosition)
  self.ball:moveTo(self.paddle.x, paddleY - ballRadius)
  self.ball:setSpeed(0, 0)
  self.moving = false
  self.playing = true
end

function GameScreen:draw()
  if self.playing then
    self.ball:tick()
    self.paddle:tick()
  end
end

function GameScreen:createPoints()
  for row = 0, rows, 1 do
    local y = rowOffset + row * rowHeight
    for column = 0, columns, 1 do
      local x = columnOffset + column * columnWidth
      local block = Block(x, y, (row % 4) + 1, self.onCollide)
      block.name = 'BLOCK'

      table.insert(self.points, block)
    end
  end
end

function GameScreen:hitBottom()
  self.ball:setSpeed(0, 0)
  self.playing = false
  self.gameOverDialog:add()
end

function GameScreen:score()
  self.scored = self.scored + 1

  if self.scored == #self.points then
    self.setState(GAME_WIN_STATE)
  end
end

function GameScreen:cranked(_, accelerated)
  local halfPaddle = 16
  local xMin = halfPaddle
  local xMax = WIDTH - halfPaddle

  if self.playing == false then
    return
  end

  local oldPosition = paddlePosition
  paddlePosition = paddlePosition + accelerated

  if paddlePosition < xMin then
    paddlePosition = xMin
  elseif paddlePosition > xMax then
    paddlePosition = xMax
  end

  if oldPosition < paddlePosition then
    self.paddleDirection = paddleDirectionRight
  elseif oldPosition > paddlePosition then
    self.paddleDirection = paddleDirectionLeft
  else
    self.paddleDirection = paddleDirectionStatic
  end

  self.paddle:moveBy(accelerated)

  if self.moving == false then
    self.ball:moveTo(self.paddle.x, paddleY - ballRadius)
  end
end