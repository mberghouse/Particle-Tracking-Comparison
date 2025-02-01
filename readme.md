# Evaluation of Particle Tracking Codes for Dispersing Particles in Porous Media

![Particle Tracking Comparison](https://github.com/mberghouse/Particle-Tracking-Comparison/assets/55556564/a3b3792a-fba3-4d8a-8b39-aed439a8b479)

The work presented here has now been **published**. Please see the article here:  
[EVALUATION OF PARTICLE TRACKING CODES FOR DISPERSING PARTICLES IN POROUS MEDIA](https://www.nature.com/articles/s41598-024-75581-0)

---

## Overview

This repository compares various particle tracking codes used to simulate and analyze the dispersion of particles within porous media. It includes simulation files, trajectory tracking implementations, and analysis scripts to evaluate performance and accuracy using several quantitative metrics. Please note that this code is still a work in progress and may require modifications before use.

---

## Included Files and Directories

- **OF_PT_sim_master2.m**  
  Main simulation file. To experiment with different simulations, you will need to import velocity vector data (here, using OpenFOAM).

- **Filippo_new.zip**  
  Contains the V-TrackMat particle tracking code with modifications aimed at speeding up the calculations and offering a larger search radius for linking particles.

- **format_filipo.m**  
  A script that converts trajectories from the UNIL code into a simple array format that is easier to manipulate.

- **ParticleTrackingComparison_FinalTrajectories.zip**  
  Archive containing both the V-TrackMat trajectories and the simulated trajectories used in each set of experiments.

- **ParticleTrackingComparison_results_test.zip**  
  A test folder to verify that the results are correctly output.

- **PT_comparison.py**  
  A Python script that calculates:
  - Euclidean distances between simulated and predicted trajectories.
  - Path lengths for each trajectory.
  - False detection rates (as a comparison of false versus true detections).

- **vel_angle_calc.py**  
  A Python script that computes velocities and turning angles for each step in every trajectory.

- **PT_sim_figures.m**  
  A MATLAB script that reads in simulation and tracking analysis outputs (euclidean distances, trajectory path lengths, false detection rates, velocities, turning angles) and generates data visualizations. Note that modifications may be needed if you are using additional tracking codes such as Trackpy and Trackmate or if your file indices differ.

---

## Usage

1. **Simulations:**  
   Run `OF_PT_sim_master2.m` for the simulation. Ensure you have the required OpenFOAM velocity vector data available.

2. **Trajectory Generation:**  
   Use the provided tracking codes (e.g., V-TrackMat included in `Filippo_new.zip`) to generate particle trajectories.  
   If necessary, run `format_filipo.m` to convert the trajectories from the UNIL code into a simple array format.

3. **Result Analysis:**  
   - Execute `PT_comparison.py` to evaluate tracking results using metrics such as Euclidean distance and false detection rates.
   - Use `vel_angle_calc.py` to compute and analyze velocity and turning angle data.

4. **Visualization:**  
   Open `PT_sim_figures.m` in MATLAB to generate figures that illustrate:
   - Mean distances versus simulation speeds (with particle size indicating the number of particles).
   - Corresponding path lengths and false detection rates.
   - Additional plots for velocity and turning angle data.

---

## Contributing and Feedback

If you would like to use, modify, or contribute to any part of this code, please feel free to get in touch. Edits, suggestions, and improvements are welcomed. Since this repository is still undergoing development, direct contact via email is preferred.

For further details or inquiries, please contact [marc.berghouse@gmail.com].

---

Enjoy exploring and analyzing particle tracking in porous media!





