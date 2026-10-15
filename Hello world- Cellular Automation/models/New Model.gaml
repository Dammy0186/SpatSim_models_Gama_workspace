
/**
* Name: African Savannah
* Author: Damilola
* Tags: 
*/model african_savannah

// ===================== Global Section=====================
global {

    init {
        create lions number: 20;
        create zebras number: 20;
    }
}

species lions skills: [moving] {

    reflex move {
        do wander amplitude: 60.0;
    }
    reflex hunt {
        ask zebras at_distance 5 {
            do die;
        }
    }
    aspect default {
        draw circle(3) color: #orange;
    }
}

species zebras skills: [moving] {

    reflex move {
        do wander;
    }

    aspect default {
        draw triangle(2) color: #gray;
    }

}

grid grassland width: 50 height: 50 {

    // Initial biomass: random value between 0 and 10 kg
    float biomass <- rnd(10.0);

    // Grass grows by 0.1 kg every time step
    reflex grow {
        biomass <- biomass + 0.1;
    }

//===================Visualize the grassland===================
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

// =====================EXPERIMENT=====================

experiment main_experiment type: gui {

    output {
        display savannah {
            grid grassland ;
            species lions aspect: default;
            species zebras aspect: default;
        }
    }
}