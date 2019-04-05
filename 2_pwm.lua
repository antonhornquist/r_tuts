-- scriptname: 2_pwm
-- v1.1.0 @jah

engine.name = 'R'

local R = require 'r/lib/r'
local Formatters = require 'formatters'

function init()
  engine.new("LFO", "MultiLFO")
  engine.new("Osc", "PulseOsc")
  engine.new("SoundOut", "SoundOut")

  engine.connect("LFO/Sine", "Osc/PWM")
  engine.connect("Osc/Out", "SoundOut/Left")
  engine.connect("Osc/Out", "SoundOut/Right")

  local lfo_frequency_spec = R.specs.MultiLFO.Frequency:copy()
  lfo_frequency_spec.default = 0.2

  params:add {
    type="control",
    id="lfo_frequency",
    name="LFO.Frequency",
    controlspec=lfo_frequency_spec,
    formatter=Formatters.round(0.001),
    action=function(value) engine.set("LFO.Frequency", value) end
  }

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

  local lfo_to_osc_pwm_spec = R.specs.PulseOsc.PWM:copy()
  lfo_to_osc_pwm_spec.default = 0.6

  params:add {
    type="control",
    id="lfo_to_osc_pwm",
    name="LFO > Osc.PWM",
    controlspec=lfo_to_osc_pwm_spec,
    formatter=Formatters.percentage,
    action=function(value) engine.set("Osc.PWM", value) end
  }

  params:bang()
end

function redraw()
  screen.clear()
  screen.level(15)
  screen.move(0, 10)
  screen.text("PWM")
  screen.move(0, 30)
  screen.text("See params in menu")
  screen.update()
end

function enc(n, delta)
  if n == 1 then
    mix:delta("output", delta)
  end
end
