import 'CoreLibs/object'

class('BounceCalculator').extends(object)

local XMAX = 5
local XMID = 4
local XSTD = 2
local YMAX = 4
local YMID = 3
local YSTD = 2

function BounceCalculator:init(max, min, direction)
  BounceCalculator.super:init(self)
  self.intensity = min
  self.max = max
  self.min = min
  self.direction = direction
end

function BounceCalculator:setDirection(direction)
  self.direction = direction
end

function BounceCalculator:increaseBy(amount)
  self.intensity = math.min(self.max, self.intensity + amount)
end

function BounceCalculator:decreaseBy(amount)
  self.intensity = math.max(self.min, self.intensity - amount)
end

function BounceCalculator:setIntensity(newIntensity)
  if newIntensity > self.max then
    newIntensity = max
  elseif newIntensity < min then
    newIntensity = min
  end

  self.intensity = newIntensity
end

function BounceCalculator:calculateSpeed(x, y)
  if self.direction == 0 then
    -- Paddle is stationary
    -- No modifiers to speed needed
    return x, y
  elseif self.direction < 0 then
    -- Paddle is moving left
    if x < 0 then
      -- Ball is moving left
      if self.intensity == 1 then
        return x, y
      elseif self.intensity == 2 then
        return -XMID, -YMID
      elseif self.intensity == 3 then
        return -XMAX, -YMAX
      end
    else
      -- Ball is moving right
      if self.intensity == 1 then
        return XSTD, -YSTD
      elseif self.intensity == 2 then
        return XMID, -YMID
      elseif self.intensity == 3 then
        return XMAX, -YMAX
      end
    end
  elseif self.direction > 0 then
    -- Paddle is moving right
    if x < 0 then
      -- Ball is moving left
      if self.intensity == 1 then
        return -XSTD, -YSTD
      elseif self.intensity == 2 then
        return -XMID, -YMID
      elseif self.intensity == 3 then
        return -XMAX, -YMAX
      end
    else
      -- Ball is moving right
      if self.intensity == 1 then
        return x, y
      elseif self.intensity == 2 then
        return XMID, -YMID
      elseif self.intensity == 3 then
        return XMAX, -YMAX
      end
    end
  end
end