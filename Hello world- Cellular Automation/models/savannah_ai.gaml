/**
* Name: savannah_ai
* Author: Administrator
* Description: Grassland Cellular Automaton model where each cell starts with random biomass (0–10 kg), grows by 0.1 kg per cycle, and is visually displayed.
* Tags: cellular_automaton, grid, grassland
*/
model savannah_ai

// Global section defining simulation environment parameters
global {
}

// Grid species representing the grassland cellular automaton
grid grassland width: 50 height: 50 {

	// Attribute representing the biomass of the cell in kilograms (random between 0.0 and 10.0 kg)
	float biomass <- rnd(10.0);

	// Reflex defining the linear grass growth of 0.1 kg per simulation cycle
	reflex grow {
		biomass <- biomass + 0.1;
	}

	// Attribute defining the cell display color updated dynamically according to biomass level
	rgb color <- rgb(
		255 - int(min([biomass, 10.0]) * 25.5),
		255,
		255 - int(min([biomass, 10.0]) * 25.5)
	) update: rgb(
		255 - int(min([biomass, 10.0]) * 25.5),
		255,
		255 - int(min([biomass, 10.0]) * 25.5)
	);
}

// GUI Experiment to run and visualize the grassland simulation
experiment main_experiment type: gui {

	// Output block containing visualization displays
	output {
		// Visual display showing the grassland CA grid
		display savannah_display {
			grid grassland;
		}
	}
}
