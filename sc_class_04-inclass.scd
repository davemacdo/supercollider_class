s.boot
s.meter
(
SynthDef.new(\noise_gate, {
	var sig_in = SoundIn.ar;
	var thresh1 = -40.dbamp;
	var thresh2 = -20.dbamp;
	var amp = Amplitude.kr(sig_in, 0.03, 0.03);
	var gate1 = Lag.kr(amp > thresh1, 0.01);
	var gate2 = Lag.kr(amp > thresh2, 0.01);

	// SendTrig.kr(gate, value: 1);
	SendReply.kr(gate1, '/reply', 1);
	SendReply.kr(gate2, '/reply', 2);
}).add;

OSCdef.new(\controller, {
	|msg|
	if (msg[3] == 1) {
		// "foobar".postln;
		y = Synth.new(\ping);
	};
	if (msg[3] == 2) {
		// "foobar".postln;
		z = Synth.new(\slam);
	};
}, '/reply');
)

x = Synth.new(\noise_gate);
x.free

(
SynthDef.new(\ping, {
	var freq = ExpRand(330, 990);
	var env = EnvGen.kr(Env.perc, doneAction: 2);
	var sig = SinOsc.ar(freq, mul: env).dup;

	Out.ar(0, sig * 0.5);
}).add;

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

y = Synth.new(\slam);
