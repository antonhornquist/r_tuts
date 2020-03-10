(
s.waitForBoot {r=Rrrr.new};
)

r.newCommand("LFO", "MultiLFO");
r.newCommand("Osc", "PulseOsc");
r.newCommand("SoundOut", "SoundOut");

r.connectCommand("LFO/Sine", "Osc*PWM");
r.connectCommand("Osc/Out", "SoundOut*Left");
r.connectCommand("Osc/Out", "SoundOut*Right");

r.setCommand("LFO.Frequency", 1);
r.setCommand("LFO.Frequency", 10);
r.setCommand("LFO.Frequency", 25);

r.setCommand("Osc.Range", -1);
r.setCommand("Osc.Range", 0);
r.setCommand("Osc.Range", -2);

r.setCommand("Osc.Tune", -600)
r.setCommand("Osc.Tune", 423)
r.setCommand("Osc.Tune", 0)

r.setCommand("Osc.PulseWidth", 0.25);
r.setCommand("Osc.PulseWidth", 0.5);
r.setCommand("Osc.PulseWidth", 0.75);

r.setCommand("Osc.PWM", 0.6);
r.setCommand("Osc.PWM", 0.2);
r.setCommand("Osc.PWM", 0);



