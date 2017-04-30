(
SynthDef.new(\dm_thick_texture, {
	|out=0, freq=55, detune=0|
	var sig, env;
	var numComponents = 3;

	sig = VarSaw.ar(
		freq: Array.fill(numComponents, {|voice| (freq * ((voice+1) * 3/2)) * Rand(1-detune,1+detune)}),
		iphase: Array.fill(numComponents, {Rand(0.0, 1.0)}),
		width: Array.fill(numComponents, {Rand(0.0, 1.0)}),
		mul: Array.fill(numComponents, {Rand(0.05, 0.2)})
	);
	sig = Mix(sig).dup;
	env = EnvGen.kr(Env.new([0, 1, 0], [5, 7]), doneAction: 2);

	Out.ar(out, sig * env);
}).add;
)

x = Synth.new(\dm_thick_texture);
x.free;

e = Pgauss.new(400,10).poll(0.2);
e.asStream.nextN(500);

/*
V. In-Class Assignment:

Take the \thick_texture SynthDef (at any of its evolutionary stages) and tinker with it.
Feel free to change anything: the number of components of the texture,
its envelope, the VarSaw UGen itself, &c. Try to come up with a complex sound/texture of your own
to use in future projects.
*/