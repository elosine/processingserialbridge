OSCdef(\hit, {
	arg msg;
	~fl.set(\t_tr, 1);
	msg.postln;
}, "/hit");

SynthDef(\formlet, {
	arg t_tr = 0;
	var sig;
	sig = Formlet.ar(K2A.ar(t_tr), 1000, 0.01, 0.1);
	Out.ar(0, sig);
}).add;

~fl = Synth(\formlet);
~fl.set(\t_tr, 1)