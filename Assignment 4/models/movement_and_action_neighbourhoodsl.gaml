/**
* Name: movementandactionneighbourhoodsl
* Author: Administrator
* Description: Model 2 simulating spatial action neighbourhoods for cows, sheep, and goats.
* Tags: movement, action_neighbourhoods, spatial_action
*/
model movementandactionneighbourhoodsl

// Global section defining simulation environment parameters and agent initialization
global {

	// Attribute indicating whether the simulation has ended
	bool simulation_ended <- false;

	// List recording direction changes of cows
	list<float> cow_direction_changes <- [];

	// Attribute tracking the cumulative distance moved by sheep on the first step
	float first_step_sheep_dist <- 0.0;

	// Attribute tracking the cumulative distance moved by cows on the first step
	float first_step_cows_dist <- 0.0;

	// Initialization block creating initial simulation agents
	init {
		// Initialize 5 cow agents
		create cows number: 5;
		// Initialize 3 sheep agents
		create sheep number: 3;
		// Initialize 2 goat agents
		create goats number: 2;
	}

	// Reflex calculating the mean distance travelled on the first step for sheep and cows at cycle 1
	reflex record_first_step_metrics when: cycle = 1 {
		first_step_sheep_dist <- mean(sheep collect each.cumulative_dist);
		first_step_cows_dist <- mean(cows collect each.cumulative_dist);
	}

	// Reflex checking if all sheep reached South and all goats reached origin to terminate simulation and export metrics to CSV
	reflex check_end_condition {
		if (empty(sheep where (each.location.y < 95.0)) and empty(goats where (each.location distance_to {0,0} >= 1.0)) and !simulation_ended) {
			write "ALL SHEEP REACHED SOUTH & ALL GOATS REACHED ORIGIN. Simulation successfully finished!";
			save [cycle, mean(goats collect each.cumulative_dist), first_step_sheep_dist, first_step_cows_dist, cow_direction_changes] to: "../results/simulation_data.csv" format: "csv" rewrite: false;
			simulation_ended <- true;
			do pause;
		}
	}
}

// Species representing cows that move via correlated random walk
species cows skills: [moving] {

	// Attribute representing the movement speed of the cow
	float speed <- 2.0;

	// Attribute tracking the cumulative distance traveled by the cow
	float cumulative_dist <- 0.0;

	// Attribute tracking the previous heading of the cow
	float previous_heading <- heading;

	// Attribute representing the spatial action area geometry of the cow, updated every cycle
	geometry action_area <- circle(speed) intersection cone(heading - 45, heading + 45) update: circle(speed) intersection cone(heading - 45, heading + 45);

	// Initialization block setting initial heading reference
	init {
		previous_heading <- heading;
	}

	// Reflex enabling cows to move via correlated random walk with a 90 degree turning amplitude, update metrics and action area
	reflex move {
		point prev_loc <- location;
		do wander amplitude: 90.0 speed: 2.0;
		float dist <- location distance_to prev_loc;
		cumulative_dist <- cumulative_dist + dist;
		float diff <- heading - previous_heading;
		loop while: (diff > 180.0) {
			diff <- diff - 360.0;
		}
		loop while: (diff < -180.0) {
			diff <- diff + 360.0;
		}
		add diff to: cow_direction_changes;
		previous_heading <- heading;
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

	// Attribute tracking the cumulative distance traveled by the sheep
	float cumulative_dist <- 0.0;

// Attribute representing the spatial action area geometry of the sheep, updated every cycle
	geometry action_area <- line([location, location + {speed * cos(heading), speed * sin(heading)}]) update: line([location, location + {speed * cos(heading), speed * sin(heading)}]);

	// Reflex enabling sheep to set heading to 90 degrees (South), move forward, track distance, and update action area
	reflex move {
		point prev_loc <- location;
		heading <- 90.0;
		do move speed: 1.0;
		cumulative_dist <- cumulative_dist + (location distance_to prev_loc);
		action_area <- line([location, location + {speed * cos(heading), speed * sin(heading)}]);
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

	// Attribute tracking the cumulative distance traveled by the goat
	float cumulative_dist <- 0.0;

	// Attribute representing the spatial action area geometry of the goat, updated every cycle
	geometry action_area <- line([location, {0,0}]) intersection (circle(speed) at_location location) update: line([location, {0,0}]) intersection (circle(speed) at_location location);
	
	// Reflex enabling goats to move towards the origin target {0,0}, track distance if not at origin, and update action area
	reflex move {
		point prev_loc <- location;
		do goto target: {0,0} speed: 0.5;
		if (location != {0,0}) {
			cumulative_dist <- cumulative_dist + (location distance_to prev_loc);
		}
		action_area <- line([location, {0,0}]) intersection (circle(speed) at_location location);
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
		layout #split;

		display "Action Neighbourhoods Display" {
			species cows aspect: default;
			species cows aspect: action_neighbourhood transparency: 0.5;
			species sheep aspect: default;
			species sheep aspect: action_neighbourhood transparency: 0.5;
			species goats aspect: default;
			species goats aspect: action_neighbourhood transparency: 0.5;
		}

		monitor "Simulation Cycle" value: cycle;
		monitor "Goats at Origin" value: goats count (each.location distance_to {0,0} < 1.0);

		display "Goat Distance Chart" type: 2d {
			chart "Mean Total Distance Travelled (Goats)" type: series {
				data "Mean Goat Distance" value: mean(goats collect each.cumulative_dist) color: #orange;
			}
		}

		display "Step 1 Scatterplot" type: 2d {
			chart "Sheep vs. Cows First Step Avg Distance" type: scatter x_label: "Species (1=Sheep, 2=Cows)" y_label: "Avg Distance" {
				data "Sheep" value: [1.0, first_step_sheep_dist] color: #black;
				data "Cows" value: [2.0, first_step_cows_dist] color: #saddlebrown;
			}
		}

		display "Cow Turn Histogram" type: 2d {
			chart "Angle Distribution of Cow Turnings (5 deg bins)" type: histogram {
				data "-45..-40" value: cow_direction_changes count (each >= -45.0 and each < -40.0) color: #goldenrod;
				data "-40..-35" value: cow_direction_changes count (each >= -40.0 and each < -35.0) color: #goldenrod;
				data "-35..-30" value: cow_direction_changes count (each >= -35.0 and each < -30.0) color: #goldenrod;
				data "-30..-25" value: cow_direction_changes count (each >= -30.0 and each < -25.0) color: #goldenrod;
				data "-25..-20" value: cow_direction_changes count (each >= -25.0 and each < -20.0) color: #goldenrod;
				data "-20..-15" value: cow_direction_changes count (each >= -20.0 and each < -15.0) color: #goldenrod;
				data "-15..-10" value: cow_direction_changes count (each >= -15.0 and each < -10.0) color: #goldenrod;
				data "-10..-5" value: cow_direction_changes count (each >= -10.0 and each < -5.0) color: #goldenrod;
				data "-5..0" value: cow_direction_changes count (each >= -5.0 and each < 0.0) color: #goldenrod;
				data "0..5" value: cow_direction_changes count (each >= 0.0 and each < 5.0) color: #goldenrod;
				data "5..10" value: cow_direction_changes count (each >= 5.0 and each < 10.0) color: #goldenrod;
				data "10..15" value: cow_direction_changes count (each >= 10.0 and each < 15.0) color: #goldenrod;
				data "15..20" value: cow_direction_changes count (each >= 15.0 and each < 20.0) color: #goldenrod;
				data "20..25" value: cow_direction_changes count (each >= 20.0 and each < 25.0) color: #goldenrod;
				data "25..30" value: cow_direction_changes count (each >= 25.0 and each < 30.0) color: #goldenrod;
				data "30..35" value: cow_direction_changes count (each >= 30.0 and each < 35.0) color: #goldenrod;
				data "35..40" value: cow_direction_changes count (each >= 35.0 and each < 40.0) color: #goldenrod;
				data "40..45" value: cow_direction_changes count (each >= 40.0 and each <= 45.0) color: #goldenrod;
			}
		}
	}
}
