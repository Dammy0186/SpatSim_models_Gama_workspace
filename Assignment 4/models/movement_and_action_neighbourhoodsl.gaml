/**
* Name: movementandactionneighbourhoodsl
* Author: Administrator
* Description: Model 2 simulating spatial action neighbourhoods for cows, sheep, and goats.
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

	// Attribute representing the spatial action area geometry of the cow, updated every cycle
	geometry action_area <- circle(speed) intersection cone(heading - 45, heading + 45) update: circle(speed) intersection cone(heading - 45, heading + 45);

	// Reflex enabling cows to move via correlated random walk with a 90 degree turning amplitude and update action area
	reflex move {
		do wander amplitude: 90.0 speed: 2.0;
		action_area <- circle(speed) intersection cone(heading - 45, heading + 45);
	}

	// Default aspect rendering the saddlebrown cow agent geometry
	aspect default {
		draw circle(2) color: #saddlebrown;
	}

	// Action area aspect rendering the action_area geometry drawn in #goldenrod
	aspect action_neighbourhood {
		if (action_area != nil) {
			draw action_area color: #goldenrod;
		}
	}
}

// Species representing sheep that move South
species sheep skills: [moving] {

	// Attribute representing the movement speed of the sheep
	float speed <- 1.0;

	// Attribute representing the spatial action area line of the sheep
	geometry action_area <- line([location, location + {0, speed}]) update: line([location, location + {0, speed}]);

	// Reflex enabling sheep to set heading to 90 degrees (South) and move forward
	reflex move {
		heading <- 90.0;
		do move speed: 1.0;
	}
	
	// Default aspect rendering the black sheep agent geometry
	aspect default {
		draw circle(1.5) color: #black;
	}

	// Action area aspect rendering the action_area geometry drawn in #goldenrod with line width 3
	aspect action_neighbourhood {
		if (action_area != nil) {
			draw (action_area + 0.4) color: #orange border: #darkorange;
		}
	}
}

// Species representing goats that move towards the origin target {0,0}
species goats skills: [moving] {

	// Attribute representing the movement speed of the goat
	float speed <- 0.5;

	// Attribute representing the spatial action area geometry of the goat
	geometry action_area <- line([location, {0,0}]) intersection (circle(speed) at_location location) update: line([location, {0,0}]) intersection (circle(speed) at_location location);

	// Reflex enabling goats to move towards the origin target {0,0}
	reflex move {
		if (location != {0,0}) {
			do goto target: {0,0} speed: 0.5;
		}
	}

	// Default aspect rendering the yellow goat agent geometry
	aspect default {
		draw circle(1) color: #yellow;
	}

	// Action area aspect rendering the action_area geometry drawn in #goldenrod with line width 3
    aspect action_neighbourhood {
		if (action_area != nil and location != {0,0}) {
			draw (action_area + 0.4) color: #orange border: #darkorange;
		}
	}
}

// GUI experiment block named main_experiment displaying all species and their action neighbourhoods
experiment main_experiment type: gui {

	output {
		display "Action Neighbourhoods Display" {
			species cows aspect: default;
			species cows aspect: action_neighbourhood transparency: 0.5;
			species sheep aspect: default;
			species sheep aspect: action_neighbourhood transparency: 0.5;
			species goats aspect: default;
			species goats aspect: action_neighbourhood transparency: 0.5;
		}
	}
}
