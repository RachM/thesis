ATSP
====

Source for calculating the length scales, Dj and NCD between ATSP instances. Also compares the NCD results to the J-divergence results. Used in the experiments in Sections 7.5, 8.3.7 and 8.4.2 of [1].

To use:

calculateDistributionsAndKL.m:
  - Script for calculating the length scale distributions and KL divergence

calculateNCD.sh:
  - Shell script for calculating the NCD between instances
  - Assumes:
    - saveAtspAsBinary has been run
    - suitable compressors are on the file system

compareDjToNCD.m:
  - Creates plots for comparing the J-divergence results to the NCD results
  
plotDjResults.m:
  - Script for plotting the J-divergence visualisations, heatmaps and dendrograms
  
plotNCDResults.m:
  - Script for plotting the NCD visualisations, heatmaps and dendrograms

saveAtspAsBinary.m:
  - Saves the ATSP length scales as binary files in order to perform NCD

zhangExperiment.m:
  - Script for producing Zhang's [2] results.

[1] R. Morgan. Analysing and Comparing Problem Landscapes for Black-Box Optimization via Length Scale. PhD thesis, The University of Queensland, 2015.

[2]  W. Zhang. Phase transitions and backbones of the asymmetric traveling salesman problem. Journal of Artificial Intelligence Research, 21(1):471–497, 2004.