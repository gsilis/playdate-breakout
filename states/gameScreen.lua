import 'CoreLibs/object'
import 'CoreLibs/sprites'
import 'states/screen'
import 'sprites/paddle'
import 'sprites/ball'
import 'sprites/block'

class('GameScreen').extends(Screen)

local WIDTH = 400
local HALF_WIDTH = WIDTH / 2
local HEIGHT = 240
local HALF_HEIGHT = HEIGHT / 2
local graphics = playdate.graphics
local sprite = graphics.sprite
local image = graphics.image
local initialPaddleWidth = 32
local initialPaddlePosition = HALF_WIDTH
local paddleY = HEIGHT - 30
local BLACK = graphics.kColorBlack
local WHITE = graphics.kColorWhite
local ballRadius = 6
local ballDiameter = ballRadius * 2
local initialBallY = paddleY
local initialBallX = initialPaddlePosition
local rows = 8
local columns = 23
local columnOffset = 16
local columnWidth = 16
local rowOffset = 32
local rowHeight = 8
local initialSpeedX = -4
local initialSpeedY = -4
local font = graphics.getFont(BOLD)
local LEFT = kTextAlignment.left

-- Variables used for drawing
local paddlePosition = initialPaddlePosition
local paddleWidth = initialPaddleWidth
local paddleHeight = 10
local speedX = initialSpeedX
local speedY = initialSpeedY
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
  self.paddle = Paddle(paddlePosition, paddleY)
  self.ball = Ball(initialBallX, initialBallY, 0, 0, self)

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
  self.score = 0
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
    self.ball:setSpeed(speedX, speedY)
  end
end

function GameScreen:BButtonUp()
  self.moving = not self.moving

  if self.moving then
    self.ball:setSpeed(speedX, speedY)
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
  paddlePosition = initialPaddlePosition
  paddleWidth = initialPaddleWidth

  self.paddle:moveTo(paddlePosition, paddleY)
  self.ball:moveTo(initialBallX, initialBallY)
  self.moving = false
  self.playing = true
end

function GameScreen:draw()
  self.ball:tick()

  if self.playing == false then
    graphics.setColor(WHITE)
    graphics.fillRect(HALF_WIDTH - 80, HEIGHT - 30, 200, 30)
    font:drawTextAligned('Press A for new game', HALF_WIDTH - 70, HEIGHT - 20, 100, 30, LEFT)
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
end

function GameScreen:scorePoint(point)
  point:remove()
  self.score = self.score + 1

  if self.score == #self.points then
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

  paddlePosition = paddlePosition + accelerated

  if paddlePosition < xMin then
    paddlePosition = xMin
  elseif paddlePosition > xMax then
    paddlePosition = xMax
  end

  if self.moving == false then
    self.ball:moveTo(paddlePosition, paddleY - ballRadius)
  end

  self.paddle:moveTo(paddlePosition, paddleY)
end