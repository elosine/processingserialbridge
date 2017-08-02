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

~b1 = Buffer.read(s,"/home/jyang/Documents/processingserialbridge/shutter.wav" );

SynthDef(\samp, {
	arg buf, spd;
	var sig;
	sig = PlayBuf.ar(2, buf,spd, doneAction:2);
	Out.ar(0, sig);
}).add;

OSCdef(\samp1, {
	arg msg;
	a = Synth(\samp, [\buf, ~b1]);
	a.map(\spd, ~p0b);
}, "/samp1");

~p0b = Bus.control(s,1);

SynthDef(\setkbus, {
	arg bus;
	var val;
	val = \val.kr(0.0, 0.02);
	Out.kr(bus, val);
}).add;



OSCdef(\p0,{
	arg msg;
	var val = msg[1].asFloat;
	val = val.linlin(0.0, 1.0, 0.2, 5.0); //control speed of sample playback
	~setbs.set(\val, val);
}, "/p0");

)
~setbs = Synth(\setkbus,[\bus, ~p0b]);
~fl = Synth(\formlet);
~fl.set(\t_tr, 1, \amp, 0.2);

~samp = Synth(\samp, [\buf, ~b1]);
~p0b.get;