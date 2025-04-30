(

var delayBus, reverbBus, noiseBus, windBus;
var delaySynth, reverbSynth, noiseSynth, windSynth;
var win, view, drawDrop, windmillFactory;

// --------------------- SynthDefs ---------------------

SynthDef(\rainDelay, {
    |inBus = 0, outBus = 0|
    var input = In.ar(inBus, 2);
    var delayed = CombC.ar(input, 0.5, LFNoise1.kr(0.2).range(0.05, 0.2), 4);
    Out.ar(outBus, (input + delayed).tanh);
}).add;

SynthDef(\raindrop, {
    |freq = 440, amp = 0.2, pan = 0, decay = 1, outBus = 0|
    var env = EnvGen.kr(Env.perc(0.01, decay), doneAction: 2);
    var sig = SinOsc.ar(freq) * env * amp;
    Out.ar(outBus, Pan2.ar(sig, pan));
}).add;

SynthDef(\reverbEffect, {
    |inBus = 0, outBus = 0|
    var input = In.ar(inBus, 2);
    var reverb = FreeVerb.ar(input, mix: 0.3, room: 0.9, damp: 0.5);
    Out.ar(outBus, reverb);
}).add;

SynthDef(\atmosphericNoise, {
    |outBus = 0, intensity = 0.2|
    var noise = WhiteNoise.ar(0.1) * intensity;
    var env = EnvGen.kr(Env.perc(0.01, 2), doneAction: 2);
    Out.ar(outBus, noise * env);
}).add;

SynthDef(\windstorm, {
    |outBus = 0, intensity = 0.2, gustFrequency = 0.2|
    var windNoise, gustMod, lowPassFilter;
    windNoise = WhiteNoise.ar(0.2) * intensity;
    gustMod = LFNoise1.kr(gustFrequency).range(0.1, 0.5);
    lowPassFilter = LPF.ar(windNoise, LFNoise1.kr(0.05).range(300, 800));
    Out.ar(outBus, lowPassFilter * gustMod);
}).add;

SynthDef(\ambientLoop, {
    |out=0, amp=0.3|
    var sig, env;
    env = EnvGen.kr(Env.linen(2, 8, 4), doneAction: 2);
    sig = Mix.fill(4, {
        var f = [60, 65, 72, 79].choose.midicps;
        var detune = Rand(-0.5, 0.5);
        Saw.ar(f * (1 + detune)) * 0.2
    });
    sig = LPF.ar(sig, LFNoise1.kr(0.1).range(400, 3000));
    sig = sig * amp * env;
    Out.ar(out, sig.dup);
}).add;

SynthDef(\pianoLoop, {
    |freq = 440, amp = 0.1, out = 0|
    var sig, env;
    env = EnvGen.kr(Env.perc(0.01, 1.5, curve: -4), doneAction: 2);
    sig = SinOsc.ar(freq) * env * amp;
    sig = Pan2.ar(sig, Rand(-0.6, 0.6));
    Out.ar(out, sig);
}).add;



// --------------------- Main Boot Routine ---------------------

s.waitForBoot {

    // Audio Buses
    delayBus = Bus.audio(s, 2);
    reverbBus = Bus.audio(s, 2);
    noiseBus = Bus.audio(s, 2);
    windBus = Bus.audio(s, 2);

    // Effect Synths
    delaySynth = Synth(\rainDelay, [\inBus, delayBus, \outBus, 0]);
    reverbSynth = Synth(\reverbEffect, [\inBus, delayBus, \outBus, 0]);
    noiseSynth = Synth(\atmosphericNoise, [\outBus, noiseBus, \intensity, 0.2]);
    windSynth = Synth(\windstorm, [\outBus, windBus, \intensity, 0.5, \gustFrequency, 0.1]);

    // GUI Setup
    win = Window("Rain Painter", Rect(100, 100, 600, 400)).front;
    view = UserView(win, win.view.bounds);
    view.clearOnRefresh = false;
    view.background = Color.hsv(0.0, 0.9, 0.8);

    // --------------------- Background color cycling ---------------------
    Routine({
        var hue = 0.0;
        loop {
            view.background = Color.hsv(hue, 0.9, 0.85);
            hue = (hue + 0.01) % 1.0;
            0.03.wait;
        }
    }).play(AppClock);

    // --------------------- Ambient loop ---------------------
    Routine({
        inf.do {
            Synth(\ambientLoop);
            14.wait;
        };
    }).play(SystemClock);

    // --------------------- Windmill Shape Generator ---------------------
    windmillFactory = { |pos, size, numBlades, col|
        var angle, bladeWidth = 2.0;
        Pen.push;
        numBlades.do { |i|
            angle = i * 2pi / numBlades;
            Pen.moveTo(pos + Point(size * cos(angle), size * sin(angle)));
            Pen.lineTo(pos + Point((size + bladeWidth) * cos(angle), (size + bladeWidth) * sin(angle)));
        };
        Pen.color = col;
        Pen.stroke;
        Pen.pop;
    };

Routine({
    var notes = [60, 62, 65, 67, 69, 72, 74, 77];
    loop {
        Synth(\pianoLoop, [
            \freq, notes.choose.midicps,
            \amp, rrand(0.05, 0.15),
            \out, reverbBus
        ]);
        rrand(0.4, 1.5).wait;
    }
}).play(SystemClock);


    // --------------------- Draw Drop Function ---------------------
    drawDrop = { |x, y|
        var freq, pan, decay, amp, col, shapeType, r = 10, angle, inner, outer;

        freq = x.linlin(0, view.bounds.width, 300, 1200) * [0.5, 1.0, 1.5].choose;
        pan = x.linlin(0, view.bounds.width, -1, 1) + rrand(-0.1, 0.1);
        decay = y.linlin(0, view.bounds.height, 2, 0.1) * rrand(0.8, 1.2);
        amp = y.linlin(0, view.bounds.height, 0.1, 0.3);
        col = Color.hsv(rrand(0.0, 1.0), 0.9, 0.9);
        shapeType = [\circle, \star, \splash].choose;

        // Trigger sound
        Synth(\raindrop, [
            \freq, freq,
            \pan, pan.clip(-1, 1),
            \decay, decay,
            \amp, amp,
            \outBus, delayBus
        ]);

        // Drawing function
        view.drawFunc = {
            // Draw windmills
            forBy(0, view.bounds.width - 50, 50, { |ix|
                forBy(0, view.bounds.height - 50, 50, { |iy|
                    var windmillPos = Point(45 + ix, 45 + iy);
                    var windmillCol = Color(sin(ix/50).abs, sin(iy/50).abs, 1);
                    windmillFactory.(windmillPos, 20, (5..27).wrapAt(ix/50), windmillCol);
                });
            });

            // Draw shape
            Pen.fillColor = col.alpha(0.7);
            Pen.strokeColor = col.blend(Color.white, 0.4);
            Pen.width = 3;

            switch(shapeType,
                \circle, {
                    Pen.addOval(Rect.aboutPoint(Point(x, y), 14, 14));
                },
                \star, {
                    Pen.moveTo(Point(x + r, y));
                    5.do { |i|
                        angle = i * 2pi / 5;
                        inner = Point(x + (r * cos(angle)), y + (r * sin(angle)));
                        Pen.lineTo(inner);
                        angle = (i + 0.5) * 2pi / 5;
                        outer = Point(x + (r * 0.5 * cos(angle)), y + (r * 0.5 * sin(angle)));
                        Pen.lineTo(outer);
                    };
                },
                \splash, {
                    Pen.addOval(Rect.aboutPoint(Point(x + rrand(-6, 6), y + rrand(-6, 6)), 6, 6));
                    Pen.addOval(Rect.aboutPoint(Point(x + rrand(-4, 4), y + rrand(-4, 4)), 3, 3));
                }
            );
            Pen.fill;
            Pen.stroke;
        };

        view.refresh;
    };

    // --------------------- Mouse Interaction ---------------------
    view.mouseDownAction = { |v, x, y| drawDrop.(x, y) };
    view.mouseMoveAction = { |v, x, y| drawDrop.(x, y) };

};
)
