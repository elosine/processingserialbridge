(

OSCdef(\hit, {
	arg msg;
	var pitch = msg[1].asFloat;
	pitch = pitch.linlin(0.0, 1.0, 30, 90).round;
	~fl.set(\t_tr, 1, \pitch, pitch);
	//msg.postln;
}, "/hit");

SynthDef(\formlet, {
	arg t_tr = 0, pitch = 60, amp=0.2;
	var sig, freq;
	freq = pitch.midicps;
	sig = Formlet.ar(K2A.ar(t_tr), freq, 0.01, 0.1);
	Out.ar(0, sig*amp);
}).add;
)

~fl = Synth(\formlet);
~fl.set(\t_tr, 1, \amp, 0.2)