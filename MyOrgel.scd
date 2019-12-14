(
SynthDef(\My_little_Synth, {
	 |mainFreq = 440 modSaw = 0, gainSaw = 1, perc = 1, long = 1|
	var oute, preSig1, preSig2, modulSaw, envMain, amp;
	preSig1 = Pulse.ar(freq: mainFreq, width: 0.5, mul: 1.0, add: 0.0);
	preSig2 = Saw.ar(freq: mainFreq,  mul: 1.0,  add: 0.0 );
	modulSaw = SinOsc.kr(freq: modSaw, mul:gainSaw );
	preSig2 = preSig2 * modulSaw;
	oute = preSig1 + preSig2;
	envMain = Env.perc(1/perc, 1000, 1);
	amp = EnvGen.kr(envMain, doneAction: 2);
	oute = oute*amp;
	Out.ar(0, oute);
}).add;
)
x = Synth(\My_little_Synth);

( b = Routine{
	var duration, mF, newFreq, a, aStream, intervall, mD, newDuration, g, gStream;
	duration = 1;
	newFreq = 0;
	mF = 440;
	newDuration = 0;
	mD = 1;
	loop{
		g = Pxrand.new(#[0.666, 0.75, 1.333, 1.5  ], 1);
		gStream = g.asStream;

		while ( { (newDuration < 0.01) || (newDuration > 3)  }, {
			intervall = gStream.next;
			intervall.postln;
			newDuration = mD * intervall;
		});
		mD = newDuration;
		newFreq = 0;

		a = Pxrand.new(#[0.666, 0.75, 1.333, 1.5  ], 1);
		aStream = a.asStream;

		while ( { (newFreq < 20) || (newFreq > 15000)  }, {
			intervall = aStream.next;
			intervall.postln;
			newFreq = mF * intervall;
		});
		mF = newFreq;
		newFreq = 0;
		mF.postln;
		x = Synth(\My_little_Synth, [mainFreq: mF, modSaw:  Pwhite(0.3, 9, inf).asStream, gainSaw:  Pwhite(0, 1, inf).asStream, perc:  Pwhite(9, 2, inf).asStream, long:  Pwhite(0.5, 3, inf).asStream
		]);
		duration.yield;
	}

});

b.play;


( a = Routine{
	var duration;
	duration = 1;
	x = Synth(\My_little_Synth);
	loop{
		x.set(\modSaw, Pwhite(1, 10, inf).asStream,);
		x.set(\gainSaw, Pwhite(0.01, 1, inf).asStream,);
		duration.yield;
	}

});

a.play;