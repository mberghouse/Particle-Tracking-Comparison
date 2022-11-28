This folder contains everything you need to test the performance of UNIL through comparative statistics with the ground truth simulation.

OF_PT_sim_master2.m is the simulation file. If you'd like to play around with different simulations, you will need to import some velocity vector data (here I use OpenFOAM)

Filippo_new.zip contains the UNIL particle tracking code with my modifications to speed it up and provide a larger serarch radius for linking.

format_filipo.m is a small script that must be run to convert the trajectories from the UNIL code to a simple array that can be easily manipulated

ParticleTrackingComparison_FinalTrajectories.zip contains the UNIL and simulated trajectories from each set of experiments

ParticleTrackingComparison_results_test.zip is a test folder to ensure that the results are correctly outputting.

PT_comparison.py is a python script that calculates the euclidean distance between simulated and predicted trajectories, path lengths of simulated and predicted trajectories, and false detection rates of predicted trajectories

vel_angle_calc.py is a python script that calculates the velocity and turning angles for each step of each trajectory. 

PT_sim_figures.m is the matlab script I use to read in the euclidean distance, path length, false detection rate, velocity and turning angle data then plot it. I don't think all this code will work for you, because I indexed some cell data created from a loop by looking for the correct index and not using logic. Thus, some parts of the code will need to be altered since the number of filenames for you are different (since in addition to UNIL I also analyzed Trackpy and Trackmate). For euclidean distance I plot the mean distance on the y-axis, relative simulation speed (1x, 4x, 16x) on the x-axis, and the particle size represents the number of particles in the simulation ( 500, 1000, or 2000). The figures for path length and false detection rate are also organized in the same way, but for the mean path length I also compute the simulation results as a point of comparison. 

The figures folder contains come figures that I have output so far. I think there are still a couple small bugs in this whole pipeline that result in some bad solutions (I may have incorrectly saved or written over some solution results), so these are not final, but a work in progress.




