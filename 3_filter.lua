-- scriptname: 3_filter
-- v1.1.0 @jah

engine.name = 'R'

local R = require 'r/lib/r'
local Formatters = require 'formatters'

function init()
  engine.new("LFO", "MultiLFO")
  engine.new("Osc", "PulseOsc")
  engine.new("Filter", "MMFilter")
  engine.new("SoundOut", "SoundOut")

  engine.connect("LFO/Sine", "Osc*PWM")
  engine.connect("LFO/Sine", "Filter*FM")

  engine.connect("Osc/Out", "Filter*In")

  engine.connect("Filter/Lowpass", "SoundOut*Left")
  engine.connect("Filter/Lowpass", "SoundOut*Right")

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

  local filter_frequency_spec = R.specs.MMFilter.Frequency:copy()
  filter_frequency_spec.default = 2000

  params:add {
    type="control",
    id="filter_frequency",
    name="Filter.Frequency",
    controlspec=filter_frequency_spec,
    action=function(value) engine.set("Filter.Frequency", value) end
  }

  local filter_resonance_spec = R.specs.MMFilter.Resonance:copy()
  filter_resonance_spec.default = 0.4

  params:add {
    type="control",
    id="filter_resonance",
    name="Filter.Resonance",
    controlspec=filter_resonance_spec,
    formatter=Formatters.percentage,
    action=function(value) engine.set("Filter.Resonance", value) end
  }

  local lfo_to_filter_fm_spec = R.specs.MMFilter.FM:copy()
  lfo_to_filter_fm_spec.default = 0.4

  params:add {
    type="control",
    id="lfo_to_filter_fm",
    name="LFO > Filter.FM",
    controlspec=lfo_to_filter_fm_spec,
    formatter=Formatters.percentage,
    action=function(value) engine.set("Filter.FM", value) end
  }

  params:bang()
end

function redraw()
  screen.clear()
  screen.level(15)
  screen.move(1, 10)
  screen.text("FILTER")
  screen.move(1, 30)
  screen.text("See params in menu")
  screen.update()
end

function enc(n, delta)
  if n == 1 then
    mix:delta("output", delta)
  end
end
