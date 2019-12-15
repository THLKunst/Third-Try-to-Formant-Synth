(
SynthDef(\My_little_Synth, {
	|mainFreq = 440 modSaw = 0, gainSaw = 1, perc = 1, long = 1, room = 0.3, damp = 0.5, rql1 = 1, fSg1 = 1, rql2 = 1, fSg2 = 1, rql3 = 1, fSg3 = 1, rql4 = 1, fSg4 = 1, rql5 = 1, fSg5 = 1, rql6 = 1, fSg6 = 1 |
	var oute, preSig1, preSig2, modulSaw, envMain, amp, foSig1, rqls1, foSig2, rqls2, foSig3, rqls3, foSig4, rqls4, foSig5, rqls5, foSig6, rqls6;
	preSig1 = Pulse.ar(freq: mainFreq, width: 0.5, mul: 1.0, add: 0.0);
	preSig2 = Saw.ar(freq: mainFreq,  mul: 1.0,  add: 0.0 );
	modulSaw = SinOsc.kr(freq: modSaw, mul:gainSaw );
	preSig2 = preSig2 * modulSaw;
	oute = preSig1 + preSig2;
	envMain = Env.perc(1/perc, long, 1);
	amp = EnvGen.kr(envMain, doneAction: 2);
	oute = oute*amp;
	oute = FreeVerb.ar(oute, room: room, damp: damp);
	//Out.ar(0, oute, oute);


	// Phormant-Filter

	// 1.Formant Sonor
	rqls1 = SinOsc.kr(modSaw, 0, rql1*0.25);
	foSig1 = RLPF.ar(oute, 400, rqls1);
	foSig1 = HPF.ar(foSig1, 200);
	foSig1 = foSig1*0.3*fSg1;

	// 2.Formant Voll
	rqls2 = SinOsc.kr(modSaw, 0, rql2*0.25);
	foSig2 = RLPF.ar(oute, 600, rqls2);
	foSig2 = HPF.ar(foSig2, 400);
	foSig2 = foSig2*0.3*fSg2;

	// 3.Formant markant
	rqls3 = SinOsc.kr(modSaw, 0, rql3*0.25);
	foSig3 = RLPF.ar(oute, 1200, rqls3);
	foSig3 = HPF.ar(foSig2, 800);
	foSig3 = foSig3*0.3*fSg3;

	// 4.Formant näselnd
	rqls4 = SinOsc.kr(modSaw, 0, rql4*0.25);
	foSig4 = RLPF.ar(oute, 1800, rqls4);
	foSig4 = HPF.ar(foSig4, 1200);
	foSig4 = foSig4*0.3*fSg4;


	// 5.Formant hell
	rqls5 = SinOsc.kr(modSaw, 0, rql5*0.25);
	foSig5 = RLPF.ar(oute, 2600, rqls5);
	foSig5 = HPF.ar(foSig5, 1800);
	foSig5 = foSig5*0.3*fSg5;


	// 6.Formant brilliant
	rqls6 = SinOsc.kr(modSaw, 0, rql6*0.25);
	foSig6 = RLPF.ar(oute, 4000, rqls6);
	foSig6 = HPF.ar(foSig6, 2600);
	foSig6 = foSig6*0.3*fSg6;

	// Ausgang
	oute = foSig1 + foSig2 + foSig3 + foSig4 + foSig5 + foSig6;
	oute = Limiter.ar(oute, 0.9);
	Out.ar(0, [oute, oute]);
}).add;
)
x = Synth(\My_little_Synth);

( b = Routine{
	var mF, newFreq, a, aStream, intervall, mD, newDuration, g, gStream;
	newFreq = 0;
	mF = 440;
	newDuration = 0;
	mD = 1;
	loop{
		g = Pxrand.new(#[0.666, 0.75, 1.333, 1.5  ], inf);
		gStream = g.asStream;

		while ( { (newDuration < 0.1) || (newDuration > 3)  }, {
			intervall = gStream.next;
			"DurationInter:".post;
			intervall.postln;
			newDuration = mD * intervall;
		});
		mD = newDuration;
		"Duration:".post;
		newDuration = 0;

		a = Pxrand.new(#[0.666, 0.75, 1.333, 1.5  ], inf);
		aStream = a.asStream;

		while ( { (newFreq < 20) || (newFreq > 8000)  }, {
			intervall = aStream.next;
			"FreqInter:".post;
			intervall.postln;
			newFreq = mF * intervall;
		});
		mF = newFreq;
		"Freq:".post;
		mF.postln;
		newFreq = 0;
		mF.postln;
		x = Synth(\My_little_Synth, [mainFreq: mF, modSaw:  Pwhite(0.3, 9, inf).asStream, gainSaw:  Pwhite(0, 1, inf).asStream, perc:  Pwhite(9, 2, inf).asStream, long:  Pwhite(0.5, 3, inf).asStream, room:  Pwhite(0, 1, inf).asStream, damp:  Pwhite(0, 1, inf).asStream, fSg1:  Pwhite(0, 1, inf).asStream,  rql1:  Pwhite(1, 3, inf).asStream, fSg2:  Pwhite(0, 1, inf).asStream, rql2:  Pwhite(1, 3, inf).asStream, fSg3:  Pwhite(0, 1, inf).asStream, rql3:  Pwhite(1, 3, inf).asStream, fSg4:  Pwhite(0, 1, inf).asStream, rql4:  Pwhite(1, 3, inf).asStream, fSg5:  Pwhite(0, 1, inf).asStream, rql5:  Pwhite(1, 3, inf).asStream, fSg6:  Pwhite(0, 1, inf).asStream, rql6:  Pwhite(1, 3, inf).asStream
		]);
		mD.yield;
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