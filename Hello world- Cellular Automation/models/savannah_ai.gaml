/**
* Name: savannah_ai
* Author: Administrator
* Description: Savannah model with grassland cellular automaton, zebra agents, and lion predators.
* Tags: cellular_automaton, grid, grassland, zebras, lions
*/
model savannah_ai

// Global section defining simulation environment parameters and agent initialization
global {

	// List of ages of all lions present in the simulation
	list<int> lion_ages <- [];

	// Initialization block creating initial simulation agents
	init {
		// Create 20 initial zebra agents
		create zebras number: 20;
		// Create 20 initial lion agents
		create lions number: 20;
		// Populate lion_ages with the age of each created lion
		lion_ages <- lions collect each.age;
	}
}

// Species representing lions that prey on zebras in the savannah
species lions skills: [moving] {

	// Attribute representing the lion's age, initialized randomly up to 50
	int age <- rnd(50);

	// Attribute representing lion energy, initialized at 25.0 with a maximum capacity of 50.0
	float energy <- 25.0 max: 50.0;

	// Reflex enabling lions to walk around randomly with a turning amplitude of 60 degrees, losing 0.15 energy per step
	reflex move {
		do wander amplitude: 60.0;
		energy <- energy - 0.15;
	}

	// Reflex to hunt a nearby zebra, kill it using the die action, and gain 10.0 energy (capped at max energy of 50.0)
	reflex hunt {
		zebras target <- one_of(zebras at_distance 5);
		if (target != nil) {
			ask target {
				do die;
			}
			energy <- min([energy + 10.0, 50.0]);
		}
	}

	// Reflex enabling lions to age each cycle, incrementing age by 1 and updating the global lion_ages list
	reflex aging {
		remove item: age from: lion_ages;
		age <- age + 1;
		add item: age to: lion_ages;
	}

	// Default visual aspect displaying lions as orange circles of size 3
	aspect default {
		draw circle(3) color: #orange;
	}
}

// Species representing zebras that wander across the savannah
species zebras skills: [moving] {

	// Attribute representing zebra energy, initialized at 10.0 with a maximum capacity of 20.0
	float energy <- 10.0 max: 20.0;

	// Reflex enabling zebras to walk around randomly, consuming 0.2 energy per step
	reflex move {
		do wander;
		energy <- energy - 0.2;
	}

	// Reflex for zebras to graze on their current grassland cell, gaining energy and depleting biomass
	reflex graze {
		grassland current_cell <- grassland(location);
		if (current_cell != nil) {
			energy <- min([energy + current_cell.biomass, 20.0]);
			current_cell.biomass <- 0.0;
		}
	}

	// Reflex checking if energy has reached 0 or below, triggering death
	reflex check_energy {
		if (energy <= 0.0) {
			do die;
		}
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
