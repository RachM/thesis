TSPLib
====

Source for calculating the length scales, Dj and NCD between TSPLib instances. Also compares the NCD results to the J-divergence results. Used in the experiments in Sections 7.4, 8.3.6 and 8.4.2 of [1].

To use:

calculateCost.m:
  - Calculates the round-trip cost of a tour

calculateDistributionsAndKL.m:
  - Script for calculating the length scale distributions and KL divergence

calculateLengthScales.m:
  - Script for calculating the length scales

calculateNCD.sh:
  - Shell script for calculating the NCD between instances
  - Assumes:
    - saveAsBinary has been run
    - suitable compressors are on the file system

compareDjToNCD.m:
  - Creates plots for comparing the J-divergence results to the NCD results

distanceGeo.m:
  - Calculates the geographical distance described in [2]

distanceMaximum.m:
  - Calculates the maximum distance described in [2]

distancePseudoEuclidean.m:
  - Calculates the pesudo-Euclidean distance described in [1]

generateAdjacencyMatrix.m:
  - Generates an adjacency matrix based on the tour

loadTSP.m:
  - Loads the TSPLib problem with the given name and type
  
plotDjResults.m:
  - Script for plotting the J-divergence visualisations, heatmaps and dendrograms

plotLengthScaleDistributions.m
  - Script for plotting the length scale distributions
  
plotNCDResults.m:
  - Script for plotting the NCD visualisations, heatmaps and dendrograms

saveAsBinary.m:
  - Saves the TSPLib length scales as binary files in order to perform NCD

[1] R. Morgan. Analysing and Comparing Problem Landscapes for Black-Box Optimization via Length Scale. PhD thesis, The University of Queensland, 2015.

[2] G Reinelt. TSPLIB95, 1995.