(
SynthDef(\help_notRand, {
	var oute, preSig1, preSig2;
	preSig1 = Pulse.ar(freq: 440.0, width: 0.5, mul: 1.0, add: 0.0);
	preSig2 = Saw.ar(freq: 440.0,  mul: 1.0,  add: 0.0 );
	preSig1 = MouseX.kr(minval: -1, maxval: 1)*preSig1;
	preSig2 = MouseY.kr(minval: -1, maxval: 1)*preSig2;
	oute = preSig1 + preSig2;
	// oute = SinOsc.ar(rrand(400, 800), 0, 0.2) * Line.kr(1, 0, 1, doneAction: 2);
    Out.ar(0, oute);
}).add;
)
a = Synth(\help_notRand);