<h1> Code Analysis Presentation <h1>

<h2> Aestethics:<h2>

<h4> Author: eli.fieldsteel
Song name: Infinite reverberant rhythmic clusters with a marimba-like timbre.

Summary: 

The code I choose creates a generative, evolving sound texture using filtered saw waves and a custom reverb effect. It randomly generates notes and plays them with different filters and envelope parameters, creating rich, ambient textures that never quite repeat the same way. 

Explain what saw waves are...

Form: since it repeats itself and the piece is never ending there isn't a strict form. It grows over time by randomly spawning sound clusters, with changing gaps between them, making it sound ambient.

Composition: The composition is completely random, there is a limited pool of scales and pitches but they transpose so we cannot predict what the outcome will be. Because of the long envelopes and sparse scheduling the piece has a slow and meditative feel. 

explain long envelopes, sparse scheduling... <h4>

<h2> Code:<h2>

<h3> Section 1: <h3>

<h4> SynthDef(\reverb_ef, : 
- is the custom reverb effect (adds reverb to audio)
- DelayN: adds a slight delay 
- Allpass filters: 12 iterations of slightly randomized AllpassN ()
- XFade 2: blend sthe dry and wet signals ()

SynthDef(\filtSaw :
- Its a sawtooth oscillator; a detuned bank of 8 saw waves 
- SplayAz; spreads the voices across 4 channels (creating the ambient sound) <h4>

<h2> Second section: Cluster generator <h2>

<h4> Cluster generator:
- Generates a bundle of synths using random pitches and parameters 
- rrand(-7,7) makes that each cluster can shit up or down by a few semitones
- notes are chosen from a MIDI scale and converted to Hz. 
- Each synth has:
    - minCf, maxCf; a unique filters range 
    - different envelope durations 
    - spatial spread
    - ~bus; output routed to the reverb bus <h4>

<h2> Third section: Running the engine <h2>

<h4> - Just running the cluster engine i.e .start and to stop t.stop; <h4>