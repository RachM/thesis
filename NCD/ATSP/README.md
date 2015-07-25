ATSP
====

Source for calculating the NCD between ATSP instances. Also compares the NCD results to the J-divergence results.Used in the experiments in Section 8.7.3 and 8.4.2.

To use:

calculateKl.m:
  - Calculates the KL divergence between length scale distributions.

calculateNCD.sh:
  - Shell script for calculating the NCD between instances.
  - Assumes:
    - saveAtspAsBinary has been run
    - suitable compressors are on the file system
  
calculatePerplexity.m:
  - Calculates the optimal perplexity (used in t-SNE) via an exhaustive search.

compareDjToNCD.m:
  - Creates plots for comparing the J-divergence results to the NCD results
  
plotDjResults.m:
  - Script for plotting the J-divergence visualisations, heatmaps and dendrograms
  
plotNCDResults.m:
  - Script for plotting the NCD visualisations, heatmaps and dendrograms

saveAtspAsBinary.m:
  - Saves the ATSP length scales as binary files in order to perform NCD

zhangExperiment.m:
  - Script for producing Zhang's [1] results.

[1]  W. Zhang. Phase transitions and backbones of the asymmetric traveling salesman problem. Journal of Artificial Intelligence Research, 21(1):471–497, 2004.