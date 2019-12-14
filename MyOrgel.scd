(
SynthDef(\help_notRand, {
	var oute;

	// oute = SinOsc.ar(rrand(400, 800), 0, 0.2) * Line.kr(1, 0, 1, doneAction: 2);
    Out.ar(0, oute);
}).add;
)
a = Synth(\help_notRand);