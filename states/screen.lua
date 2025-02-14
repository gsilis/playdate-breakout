import 'CoreLibs/object'

class('Screen').extends()

function Screen:init(setState)
  self.setState = setState
end

function Screen:AButtonDown()
end

function Screen:AButtonHeld()
end

function Screen:AButtonUp()
end

function Screen:BButtonDown()
end

function Screen:BButtonHeld()
end

function Screen:BButtonUp()
end

function Screen:cranked()
end

function Screen:crankDocked()
end

function Screen:crankUndocked()
end

function Screen:draw()
end

function Screen:pause()
end

function Screen:resume()
end

function Screen:reset()
end