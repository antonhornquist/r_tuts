-- scriptname: 6_visual
-- v1.0.0 @jah

engine.name = 'R'

local R = require 'r/lib/r'
local Option = require 'params/option'
local Formatters = require 'formatters'
local ControlSpec = require 'controlspec'

local function to_hz(note)
  local exp = (note - 21) / 12
  return 27.5 * 2^exp
end

function init()
  engine.new("FreqGate", "FreqGate")
  engine.new("LFO", "MultiLFO")
  engine.new("Env", "ADSREnv")
  engine.new("FilterMod", "LinMixer")
  engine.new("Osc", "PulseOsc")
  engine.new("Filter", "MMFilter")
  engine.new("Amp", "Amp")
  engine.new("SoundOut", "SoundOut")

  engine.set("Osc.FM", 1)

  engine.connect("FreqGate/Frequency", "Osc*FM")
  engine.connect("FreqGate/Gate", "Env*Gate")
  engine.connect("LFO/Sine", "Osc*PWM")
  engine.connect("LFO/Sine", "FilterMod*In1")
  engine.connect("Env/Out", "FilterMod*In2")
  engine.connect("Env/Out", "Amp*Lin")
  engine.connect("FilterMod/Out", "Filter*FM")

  engine.connect("Osc/Out", "Filter*In")
  engine.connect("Filter/Lowpass", "Amp*In")
  engine.connect("Amp/Out", "SoundOut*Left")
  engine.connect("Amp/Out", "SoundOut*Right")

  engine.pollvisual(1, "Filter=Frequency") -- 1-based indexing

  local midi_note_list = {}
  for i=0,127 do
    midi_note_list[i] = i
  end

  local gate = Option.new("gate", "Gate", {0, 1})
  gate.action = function(value)
    engine.set("FreqGate.Gate", value-1)
  end
  params:add { param=gate }

  local note = Option.new("note", "Note", midi_note_list, 60)
  note.action = function(value)
    engine.set("FreqGate.Frequency", to_hz(value))
  end
  params:add { param=note }

  params:add {
    type="control",
    id="osc_tune",
    name="Osc.Tune",
    controlspec=R.specs.PulseOsc.Tune,
    action=function(value) engine.set("Osc.Tune", value) end
  }

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

  local env_attack_spec = R.specs.ADSREnv.Attack:copy()
  env_attack_spec.default = 1

  params:add {
    type="control",
    id="env_attack",
    name="Env.Attack",
    controlspec=env_attack_spec,
    action=function(value) engine.set("Env.Attack", value) end
  }

  local env_decay_spec = R.specs.ADSREnv.Decay:copy()
  env_decay_spec.default = 800

  params:add {
    type="control",
    id="env_decay",
    name="Env.Decay",
    controlspec=env_decay_spec,
    action=function(value) engine.set("Env.Decay", value) end
  }

  params:add {
    type="control",
    id="env_sustain",
    name="Env.Sustain",
    controlspec=R.specs.ADSREnv.Sustain,
    formatter=Formatters.percentage,
    action=function(value) engine.set("Env.Sustain", value) end
  }

  local env_release_spec = R.specs.ADSREnv.Release:copy()
  env_release_spec.default = 1250

  params:add {
    type="control",
    id="env_release",
    name="Env.Release",
    controlspec=env_release_spec,
    action=function(value) engine.set("Env.Release", value) end
  }

  local filter_frequency_spec = R.specs.MMFilter.Frequency:copy()
  filter_frequency_spec.default = 500

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
    action=function(value) engine.set("FilterMod.In1", value) end
  }

  local lfo_to_filter_fm_spec = R.specs.LinMixer.In2:copy()
  lfo_to_filter_fm_spec.default = 0.3

  params:add {
    type="control",
    id="env_to_filter_fm",
    name="Env > Filter.FM",
    controlspec=lfo_to_filter_fm_spec,
    formatter=Formatters.percentage,
    action=function(value) engine.set("FilterMod.In2", value) end
  }

  engine.set("FilterMod.Out", 1)
  engine.set("Filter.FM", 1)

  params:bang()

  local screen_y_spec = ControlSpec.new(64, 0, 'lin', 1)
  local frequency_visual_spec = R.specs.MMFilter.Frequency -- TODO: should be a visual spec
  val = 0
  local poll1 = poll.set("poll1", function(value)
    val = screen_y_spec:map(frequency_visual_spec:unmap(value))
    redraw()
  end)
  poll1:start()


  local screen_refresh_metro = metro.init()
  screen_refresh_metro.event = function()
    if screen_dirty then
      screen_dirty = false
      redraw()
    end
  end

  local SCREEN_FRAMERATE = 15
  screen_refresh_metro:start(1 / SCREEN_FRAMERATE)
end

function redraw()
  screen.clear()
  if not x or x > 128 then
    x = 0
  else
    x = x + 1
  end
  screen.rect(x, val, 2, 2)
  screen.fill()
  screen.level(15)
  screen.move(0, 10)
  screen.text("VISUAL")
  screen.move(0, 30)
  -- screen.text("See params in menu")
  screen.update()
end

function enc(n, delta)
  if n == 1 then
    mix:delta("output", delta)
  end
end

function key(n, z)
  if n == 3 then
    if z == 1 then
      params:set("gate", 2)
    else
      params:set("gate", 1)
    end
    redraw()
  end
end

