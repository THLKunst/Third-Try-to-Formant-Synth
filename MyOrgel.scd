(
SynthDef(\My_little_Synth, {
	 |modSaw = 0, gainSaw = 1|
	var oute, preSig1, preSig2, modulSaw;
	preSig1 = Pulse.ar(freq: 440.0, width: 0.5, mul: 1.0, add: 0.0);
	preSig2 = Saw.ar(freq: 440.0,  mul: 1.0,  add: 0.0 );
	modulSaw = SinOsc.kr(freq: modSaw, mul:gainSaw );
	preSig2 = preSig2 * modulSaw;
	oute = preSig1 + preSig2;
    Out.ar(0, oute);
}).add;
)
x = Synth(\My_little_Synth, [modSaw: 2]);

( a = Routine{
	var duration;
	duration = 1;
	x = Synth(\My_little_Synth);
	loop{
		x.set(\modSaw, Pwhite(1, 10, inf).asStream,);
		duration.yield;
	}

});

a.play;