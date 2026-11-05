## Model 2: Movement and Action Neighbourhoods Specification

- **Model Goal**: Simulate and visualize spatial action neighbourhoods for cows, sheep, and goats in GAML.
- **Entities & Dynamics**:
  * 5 Cows: brown, speed = 2, move via correlated random walk with 90° turning amplitude.
  * 3 Sheep: black, speed = 1, move South (heading = 90°).
  * 2 Goats: yellow, speed = 0.5, move towards origin target {0,0}.
- **Spatial Action Areas** (`geometry action_area`):
  * Cows: Cone slice (`circle(speed) intersection cone(heading - 45, heading + 45)`).
  * Sheep: Straight line vector in direction of motion (`line from location to location + vector`).
  * Goats: Line towards target cropped by speed buffer (`line(location, {0,0}) intersection circle(speed)`).
- **Visualization**: Render each species with two aspects in the experiment display: default colored agent geometry and `action_area` geometry drawn in `#goldenrod` with 0.5 transparency.
