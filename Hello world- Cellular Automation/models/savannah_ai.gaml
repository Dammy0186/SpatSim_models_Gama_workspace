/**
* Name: savannah_ai
* Author: Administrator
* Description: Savannah model with grassland cellular automaton, zebra agents, and lion predators.
* Tags: cellular_automaton, grid, grassland, zebras, lions
*/
model savannah_ai

// Global section defining simulation environment parameters and agent initialization
global {
	// Initialization block creating initial simulation agents
	init {
		// Create 20 initial zebra agents
		create zebras number: 20;
		// Create 20 initial lion agents
		create lions number: 20;
	}
}

// Species representing lions that prey on zebras in the savannah
species lions skills: [moving] {

	// Reflex enabling lions to walk around randomly
	reflex move {
		do wander;
	}

	// Reflex to encounter nearby zebras and kill them using the die action
	reflex hunt {
		ask zebras at_distance 5 {
			do die;
		}
	}

	// Default visual aspect displaying lions as orange circles of size 3
	aspect default {
		draw circle(3) color: #orange;
	}
}

// Species representing zebras that wander across the savannah
species zebras skills: [moving] {

	// Reflex enabling zebras to walk around randomly
	reflex move {
		do wander;
	}

	// Default visual aspect displaying zebras as grey triangles of size 2
	aspect default {
		draw triangle(2) color: #gray;
	}
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
		// Visual display showing the grassland CA grid, zebras, and lions
		display savannah_display {
			grid grassland;
			species zebras aspect: default;
			species lions aspect: default;
		}
	}
}
