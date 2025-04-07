<h1> Code Analysis Presentation <h1>

<h2> Aestethics:<h2>

#Aestethics

<h4> Author: eli.fieldsteel
Song name: Infinite reverberant rhythmic clusters with a marimba-like timbre.

Summary: 

The code I choose creates a generative, evolving sound texture using filtered saw waves and a custom reverb effect. It randomly generates notes and plays them with different filters and envelope parameters, creating rich, ambient textures that never quite repeat the same way. 

Saw waves is a type of waveform that looks like a jagged ramp because it rises steadily and drops sharply. 

Envelope parameters control how sound evolves over time. 

Form: since it repeats itself and the piece is never ending there isn't a strict form. It grows over time by randomly spawning sound clusters, with changing gaps between them, making it sound ambient.

Composition: The composition is completely random, there is a limited pool of scales and pitches but they transpose so we cannot predict what the outcome will be. Because of the long envelopes and sparse scheduling the piece has a slow and meditative feel. 

Long envelopes means that the sound takes a long time to fade in, hold and fade out and it moves slowly and smoothly. 

Sparse scheduling basically a few notes happen, spaced out over time.  <h4>

<h2> Code:<h2>

<h3> Section 1: <h3>

<h4> SynthDef(\reverb_ef, {
	arg amp=1, lPos=0, mix=0.085, revTime=1.8, preDel=0.1, in, out;
	var sig, verbSig, totalSig, outSig;

Defines the reverb effect:  
- is the custom reverb effect (adds reverb to audio)
- DelayN: adds a slight delay 
- AllpassN: 12 repeats of slighty randomized delays 
- XFade 2: blend sthe dry and wet signals 

SynthDef(\filtSaw, {
	arg freq=440, detune=3.0, atk=6, sus=4, rel=6, 

Main sound : Filtered saw wave with an envelope
- Its a sawtooth oscillator; a detuned bank of 8 saw waves 
- Envelope parameters: atk (attack), sus (sustain), rel (release), curve1/2 (shape of attack/release)
- SplayAz; spreads the voices across 4 channels (creating the ambient sound) <h4>

<h3> Second section: Cluster generator <h3>

<h4> Cluster generator:

~cluster = {
	var trnsp, bund;
	bund = s.makeBundle(false, {});
	trnsp = rrand(-7,7);

- Generates a bundle of synths using random pitches and parameters 
- Array.fill: randomly chooses how many notes to play between 4-14
- trnsp = rrand(-7,7) makes that each cluster can shit up or down by a few semitones (i.e random transposition up/down)
- Each synth has:
    - minCf, maxCf; a unique filters range 
    - different envelope durations 
    - spatial spread
    - ~bus; output sent to the reverb bus <h4>

<h3> Third section: Running the engine <h3>

<h4> - Just running the cluster engine i.e .start and to stop t.stop;
- each cluster happens every 5.5 to 12 seconds <h4>

-------------------------------------------------------------
Link to code: https://sccode.org/1-4SB#c1086

Code: (
s = Server.local.waitForBoot({
	~bus = Bus.audio(s,2);
	SynthDef(\reverb_ef, {
		arg		amp=1, lPos=0, mix=0.085, revTime=1.8, preDel=0.1, in, out;
		var		sig, verbSig, totalSig, outSig;

		//no wacky values please
		mix = mix.clip(0,1);

		sig = In.ar(in, 2);

		//pre-delay
		verbSig = DelayN.ar(sig, preDel, preDel);

		totalSig = 0;
		12.do{
			verbSig = AllpassN.ar(verbSig, 0.06, {Rand(0.001,0.06)}!2, revTime);
			verbSig = LPF.ar(verbSig, 4500);
			totalSig = totalSig + verbSig;
		};

		//dry/wet mix
		totalSig = XFade2.ar(sig, totalSig, mix.linlin(0,1,-1,1));

		outSig = totalSig * amp;
		Out.ar(out, outSig);
	}).add;

	SynthDef(\filtSaw, {
		arg		freq=440, detune=3.0, atk=6, sus=4, rel=6, curve1=1, curve2=(-1),
				minCf=30, maxCf=6000, minRq=0.005, maxRq=0.04,
				minBpfHz=0.02, maxBpfHz=0.25,
				lowShelf=220, rs=0.85, db=6,
				gate=1, amp=1, spread=1.0, out=0;
		var sig, env;
		env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[curve1,0,curve2]), gate, levelScale:amp, doneAction:2);
		sig = Saw.ar(
			freq +
			LFNoise1.kr({LFNoise1.kr(0.5).range(0.15,0.4)}!8).range(detune.neg,detune));
		sig = BPF.ar(
			sig,
			LFNoise1.kr({LFNoise1.kr(0.13).exprange(minBpfHz,maxBpfHz)}!8).exprange(minCf, maxCf),
			LFNoise1.kr({LFNoise1.kr(0.08).exprange(0.08,0.35)}!8).range(minRq, maxRq)
		);
		sig = BLowShelf.ar(sig, lowShelf, rs, db);
		sig = SplayAz.ar(4, sig, spread);
		sig = sig * env * 2;
		Out.ar(out, sig);
	}).add;

	~cluster = {
		var trnsp, bund;
		bund = s.makeBundle(false, {});
		trnsp = rrand(-7,7);
		Array.fill(exprand(4,14).round.postln, {[1,2,3,4,6,8,12,16].wchoose([7,6,5,4,3,3,1].normalizeSum)}).do{
			|i|
			var cfLo;
			cfLo = (([23,35,47,50,52,59,61,63,64,76,78].choose) + trnsp).midicps * ((1..8).choose);

				bund = s.makeBundle(false, {
					Synth(
						\filtSaw,
						[
							\freq, i,
							\detune, 0,
							\minBpfHz, 0.01,
							\maxBpfHz,i.expexp(1.0,16.0,0.1,16.0),
							\minRq, 0.003,
							\maxRq, exprand(0.008,0.08),
							\minCf, cfLo,
							\maxCf, cfLo * [1,1.1,1.5].wchoose([0.87,0.1,0.03]),
							\amp, exprand(0.15,0.25),
							\atk, exprand(0.7,8),
							\rel, 5,
							\sus, rrand(6,10.0),
							\spread, exprand(1.5,8.0),
							\out, ~bus,
						],
					)
				},
				bund
			)
		};

		//schedule on an integer time value
		SystemClock.schedAbs(
			(thisThread.seconds+1.0).round(1.0),
			{
				bund = s.makeBundle(nil, {}, bund);
				nil;
			}
		);
	};
});
)

//start clusters
(
t = Task {
	//instantiate reverb synth
	Synth(\reverb_ef, [\in, ~bus, \out, 0]);

	{
		~cluster.value;
		rrand(5.5,12.0).wait;
	}.loop;
}.start;
)

//stop clusters
t.stop;