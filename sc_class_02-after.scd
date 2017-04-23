s.boot;
s.meter;
// Filter example from class

(
SynthDef.new(\limiter, {|in=0, out=0|
	var sig_in, leaked, limited;

	sig_in = In.ar(in, 2); // Bring signal stream into synth
	leaked = LeakDC.ar(sig_in); // eliminate any built up DC offset
	limited = Limiter.ar(leaked, 0.99);  // signal maxes out JUST below unity gain

	ReplaceOut.ar(out, limited); // ReplaceOut so that the resulting signal overwrites the previous
}).add;
)

s.meter; // brings up input and output dB meters
s.plotTree; // brings up the node tree

y = Synth.after(x, \limiter); // make sure the limiter is the LAST item on the node tree
y.free;


(
SynthDef.new(\edoRamp, {
	|baseFreq = 110,scaleStep = 0,ramp=0.4,edo = 3|
	var signal,stepFreq,contour,env,pulseWidth;

	baseFreq = baseFreq * Rand(0.99, 1.01);

	contour = Line.kr(0,edo+1,ramp,doneAction:0).roundUp-1;

	// stepFreq = baseFreq * 2.pow((scaleStep)/edo);
	stepFreq = baseFreq * 2.pow((contour)/edo);
	// env = EnvGen.kr(Env.adsr, gate);
	env = EnvGen.kr(Env.new(
		[0, 0.9, 0.6, 0.4, 0],
		[0.1, 0.5, 5, 3],
		[\sine, \sine, 0, 0]), doneAction:2);

	pulseWidth = SinOsc.kr(freq:1, mul:0.2, add:0.5);

	signal = Pulse.ar(stepFreq, pulseWidth) * env;

	Out.ar(Rand(0,1).round, signal);

	}).add;
)

x.set(\t_gate,1);

SCDoc.renderAll();


x = Synth.new(\edoRamp,[\edo, 7]);

x.free;

/* UGens to research:

- SinOsc
- Saw
- LFNoise
- LFTri
- Pulse
- LFPulse
- HPF
- LPF
- BPF
- BRF

*/



/*
V. Homework

All students: Using pulseTest as a model, try replacing some more hard-coded values with flexible arguments instead.
(Hint: The phases of the LFPulse UGens may be a good place to start.) Also, feel free to try some subtractive synthesis,
perhaps even using the trackpad as a control surface, to vary the sound even more and come up with a timbre to call
your own.

For those who finish the above and want more practice: Using at least 5 of the following UGens---SinOsc, Saw, LFNoise(0 and/or 1), LFTri, Pulse, LFPulse,
HPF, LPF, BPF, BRF---come up with a unique SynthDef (or multiple if you're feeling ambitious) that you can modulate on the fly.

All students: Read through the Tour of UGens in the Help browser, try them out (avoid the Spectral and Techniques UGens for now), and write at least 2 more SynthDefs
using any combination of them as you deem fit. (Remember to use a Limiter!!)
