-- scriptname: 1_square
-- v1.1.0 @jah

engine.name = 'R'

local R = require 'r/lib/r'
local Formatters = require 'formatters'

function init()
  engine.new("Osc", "PulseOsc")
  engine.new("SoundOut", "SoundOut")

  engine.connect("Osc/Out", "SoundOut*Left")
  engine.connect("Osc/Out", "SoundOut*Right")

  params:add {
    type="control",
    id="osc_range",
    name="Osc.Range",
    controlspec=R.specs.PulseOsc.Range,
    action=function(value) engine.set("Osc.Range", value) end
  }

  params:add {
    type="control",
    id="osc_tune",
    name="Osc.Tune",
    controlspec=R.specs.PulseOsc.Tune,
    action=function(value) engine.set("Osc.Tune", value) end
  }

  params:add {
    type="control",
    id="osc_pulsewidth",
    name="Osc.PulseWidth",
    controlspec=R.specs.PulseOsc.PulseWidth,
    formatter=Formatters.percentage,
    action=function(value) engine.set("Osc.PulseWidth", value) end
  }

  params:bang()
end

function redraw()
  screen.clear()
  screen.level(15)
  screen.move(0, 10)
  screen.text("SQUARE")
  screen.move(0, 30)
  screen.text("See params in menu")
  screen.update()
end

function enc(n, delta)
  if n == 1 then
    mix:delta("output", delta)
  end
end
