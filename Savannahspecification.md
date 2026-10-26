# Unit 1 Savannah Model Specification

## Overview
Specification for the Unit 1 Savannah simulation model.

## Entities and Components

### Lions (`lions`)
- **Count**: 20 agents
- **Appearance**: Orange circle, size 3 (`draw circle(3) color: #orange`)
- **Movement**: Random movement (`wander`)
- **Interactions**: Kills zebras using the `die` action upon hunting/encounter

### Zebras (`zebras`)
- **Count**: 20 agents
- **Appearance**: Grey triangle, size 2 (`draw triangle(2) color: #gray`)
- **Movement**: Random movement (`wander`)

### Grassland Grid (`grassland`)
- **Type**: Cellular Automaton (CA) grid
- **Initial Biomass**: Uniform random value between 0 and 10 kg
- **Growth Dynamics**: Linear growth of +0.1 kg per simulation step
