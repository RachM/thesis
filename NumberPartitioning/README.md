NumberPartitioning
====

Source for calculating the length scales, Dj and NCD between Number Partitioning problem instances. Also compares the NCD results to the J-divergence results. Used in the experiments in Sections 7.6, 8.3.8 and 8.4.2 of [1].

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

generateProblems.m:
  - Script for generating the Number Partitioning problems and calculating the length scales between the problems

plotDistanceDistributions.m:
  - Script for plotting the distance distributions. See Section 7.6.1 of [1]

plotDjResults.m:
  - Script for plotting the J-divergence visualisations, heatmaps and dendrograms

plotLengthScaleDistributions.m
  - Script for plotting the length scale distributions
  
plotNCDResults.m:
  - Script for plotting the NCD visualisations, heatmaps and dendrograms

saveAsBinary.m:
  - Saves the Number Partitioning length scales as binary files in order to perform NCD

[1] R. Morgan. Analysing and Comparing Problem Landscapes for Black-Box Optimization via Length Scale. PhD thesis, The University of Queensland, 2015.