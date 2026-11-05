/**
* Name: movementandactionneighbourhoodsl
* Author: Administrator
* Description: Scaffold for Model 2 simulating spatial action neighbourhoods for cows, sheep, and goats.
* Tags: movement, action_neighbourhoods, spatial_action
*/
model movementandactionneighbourhoodsl

// Global section defining simulation environment parameters and agent initialization
global {

	// Initialization block creating initial simulation agents
	init {
		// Initialize 5 cow agents
		create cows number: 5;
		// Initialize 3 sheep agents
		create sheep number: 3;
		// Initialize 2 goat agents
		create goats number: 2;
	}
}

// Species representing cows that move via correlated random walk
species cows skills: [moving] {

	// Attribute representing the movement speed of the cow
	float speed <- 2.0;

	// Attribute representing the spatial action area geometry of the cow
	geometry action_area;

	// Default aspect rendering the brown cow agent geometry
	aspect default {
		draw circle(1.0) color: #brown;
	}

	// Action area aspect rendering the action_area geometry drawn in #goldenrod with 0.5 transparency
	aspect action_neighbourhood {
		if (action_area != nil) {
			draw action_area color: rgb(#goldenrod, 0.5);
		}
	}
}

// Species representing sheep that move South
species sheep skills: [moving] {

	// Attribute representing the movement speed of the sheep
	float speed <- 1.0;

	// Attribute representing the spatial action area geometry of the sheep
	geometry action_area;

	// Default aspect rendering the black sheep agent geometry
	aspect default {
		draw circle(1.0) color: #black;
	}

	// Action area aspect rendering the action_area geometry drawn in #goldenrod with 0.5 transparency
	aspect action_neighbourhood {
		if (action_area != nil) {
			draw action_area color: rgb(#goldenrod, 0.5);
		}
	}
}

// Species representing goats that move towards the origin target {0,0}
species goats skills: [moving] {

	// Attribute representing the movement speed of the goat
	float speed <- 0.5;

	// Attribute representing the spatial action area geometry of the goat
	geometry action_area;

	// Default aspect rendering the yellow goat agent geometry
	aspect default {
		draw circle(1.0) color: #yellow;
	}

	// Action area aspect rendering the action_area geometry drawn in #goldenrod with 0.5 transparency
	aspect action_neighbourhood {
		if (action_area != nil) {
			draw action_area color: rgb(#goldenrod, 0.5);
		}
	}
}

// GUI experiment block named main_experiment displaying all species and their action neighbourhoods
experiment main_experiment type: gui {

	output {
		display "Action Neighbourhoods Display" {
			species cows aspect: default;
			species cows aspect: action_neighbourhood;
			species sheep aspect: default;
			species sheep aspect: action_neighbourhood;
			species goats aspect: default;
			species goats aspect: action_neighbourhood;
		}
	}
}
