(
s.waitForBoot {r=Rrrr.new};
)

r.newCommand("Osc", "PulseOsc");
r.newCommand("SoundOut", "SoundOut");

r.connectCommand("Osc/Out", "SoundOut*Left");
r.connectCommand("Osc/Out", "SoundOut*Right");

r.setCommand("Osc.Range", -1);
r.setCommand("Osc.Range", 0);
r.setCommand("Osc.Range", -2);

r.setCommand("Osc.Tune", -600);
r.setCommand("Osc.Tune", 423);
r.setCommand("Osc.Tune", 0);

r.setCommand("Osc.PulseWidth", 0.25);
r.setCommand("Osc.PulseWidth", 0.5);
r.setCommand("Osc.PulseWidth", 0.75);

(
var init, free, newCommand, connectCommand, disconnectCommand, deleteCommand, setCommand, bulksetCommand, newmacroCommand, deletemacroCommand, macrosetCommand, readsampleCommand, tapoutputCommand, tapclearCommand, getTapBus, getVisualBus;
# init, free, newCommand, connectCommand, disconnectCommand, deleteCommand, setCommand, bulksetCommand, newmacroCommand, deletemacroCommand, macrosetCommand, readsampleCommand, tapoutputCommand, tapclearCommand, getTapBus, getVisualBus = RrrrScd.spawn;
~init = init;
~free = free;
~new = newCommand;
~connect = connectCommand;
~disconnect = disconnectCommand;
~delete = deleteCommand;
~set = setCommand;
~bulkset = bulksetCommand;
~newmacro = newmacroCommand;
~deletemacro = deletemacroCommand;
~macroset = macrosetCommand;
~readsample = readsampleCommand;
~tapoutput = tapoutputCommand;
~tapclear = tapclearCommand;
~getTapBus = getTapBus;
~getVisualBus = getVisualBus;

s.waitForBoot {r=init.()};
)

~new.(r, "Osc", "PulseOsc");
~new.(r, "SoundOut", "SoundOut");

~connect.(r, "Osc/Out", "SoundOut*Left");
~connect.(r, "Osc/Out", "SoundOut*Right");

~set.(r, "Osc.Range", -1);
~set.(r, "Osc.Range", 0);
~set.(r, "Osc.Range", -2);

~set.(r, "Osc.Tune", -600)
~set.(r, "Osc.Tune", 423)
~set.(r, "Osc.Tune", 0)

~set.(r, "Osc.PulseWidth", 0.25);
~set.(r, "Osc.PulseWidth", 0.5);
~set.(r, "Osc.PulseWidth", 0.75);

