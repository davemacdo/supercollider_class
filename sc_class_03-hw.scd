s.boot;
s.meter;
s.plotTree;

( // Filter
SynthDef.new(\limiter, {|in=0, out=0|
	var sig_in, leaked, limited;

	sig_in = In.ar(in, 2); // Bring signal stream into synth
	leaked = LeakDC.ar(sig_in); // eliminate any built up DC offset
	limited = Limiter.ar(leaked, 0.99);  // signal maxes out JUST below unity gain

	ReplaceOut.ar(out, limited); // ReplaceOut so that the resulting signal overwrites the previous
}).add;
)

// Synth.new if nothing is happening yet
y = Synth.new(\limiter);

// Synth.after if the audio is already running.
y = Synth.after(x, \limiter); // make sure the limiter is the LAST item on the node tree
y.free;

(
SynthDef.new(\slam, {
	|freq = 500, out = 0, dur = 0.5|
	var sig, env, tone, noise;

	//tone = Pulse.ar(freq,0.5,1);

	noise = PinkNoise.ar();
	env = EnvGen.kr(Env.perc(0.05, dur, 1, -4), doneAction: 2);
	noise = LPF.ar(noise, EnvGen.kr(Env.perc(0.001, dur, ExpRand(10000,20000), -4)));

	//sig = Mix.new([noise, tone]).dup;
	sig = noise.dup;
	Out.ar(out, sig * env * ExpRand(0.7,1));

}).add;
)

x = Synth.new(\slam, [\dur,0.9]);

Env.perc(0.05, 2, 1, -4).test.plot;
