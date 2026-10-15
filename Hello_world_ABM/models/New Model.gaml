/**
* Name: NewModel
* Based on the internal empty template. 
* Author: Administrator
* Tags: 
*/


model african_savannah

// .........Global section............
global {
    init {
        create lions number: 20;
        create zebras number: 20;
    }
}

species lions skills: [moving] {
reflex move {
do wander;
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


// .........Experiment............
experiment main_experiment type: gui {

output {

display map {
species lions aspect: default;
species zebras aspect: default;
        }
    }
}
