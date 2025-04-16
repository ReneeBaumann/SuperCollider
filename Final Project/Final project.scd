(
// Boot the server and set up the synths
s.waitForBoot {
	// Duck sound synth
	SynthDef(\duckSound, {
		arg freq = 440, amp = 0.5, out = 0;
		var sig, env;
		env = EnvGen.kr(Env([0, 1, 1, 0], [0.01, 0.3, 0.3]), 1, doneAction: 2);
		sig = SinOsc.ar(freq, 0, amp) * env;
		Out.ar(out, sig);
	}).add;

	// Create GUI window
	~gui = Window("Duck Control", Rect(100, 100, 500, 300));

	// Declare duck image and position variables
	var duckImage, duckPosition;
	duckPosition = [250, 150];  // starting position

	// Set up the duck image
	duckImage = ImageView(~gui, Rect(duckPosition[0] - 50, duckPosition[1] - 50, 100, 100));
	duckImage.image = "path/to/duck-image.png";  // replace with the correct path to the duck image

	// Slider to control the duck's position
	var positionSlider = Slider(~gui, Rect(50, 250, 200, 20));
	positionSlider.action = {
		var sliderValue = positionSlider.value.linlin(0, 1, 0, 400); // slider to move the duck horizontally
		duckPosition[0] = sliderValue;
		duckImage.bounds = Rect(duckPosition[0] - 50, duckPosition[1] - 50, 100, 100);
	};

	// Button to trigger duck sound
	var soundButton = Button(~gui, Rect(300, 250, 150, 30));
	soundButton.states = [["Play Duck Sound", Color.green]];
	soundButton.action = {
		Synth(\duckSound, [\freq, 400, \amp, 0.5, \out, 0]);
	};

	~gui.front;
};
)
