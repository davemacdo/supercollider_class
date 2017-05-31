p = Pbind(\scale, Scale.rast, \degree, Pwhite(0, 7, inf), \dur, 0.25, \legato, 4).play;
p.stop;

Scale.directory

(
p = Pbind(
	\scale, Scale.rast,
	\degree, Pwhite(0,10, inf),
	\dur, Pxrand([0.25, 0.5, 1], inf),
	\legato, 1
).play;
)

(
p = Pbind(*[
	scale: Scale.rast,
	degree: Pwhite(0,4, inf),
	dur: Pwrand([0.1, 0.2], [0.8,0.2], inf),
	legato: 1,
]).play;
)

p.stop;

