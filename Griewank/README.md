Griewank
====

Source for calculating the length scales, Dj and NCD between Griewank function instances. Also compares the NCD results to the J-divergence results. Used in the experiments in Sections 8.3.3 and 8.4.2 of [1].

To use:

calculateDistributionsAndKL.m:
  - Script for calculating the length scale distributions and KL divergence

calculateLengthScalesAndSaveAsBinary.m:
  - Script for calculating the length scales and saving as binary files

calculateNCDBetweenComponent.sh, calculateNCDBetweenGriewank.sh and calculateNCDBetweenGriewankAndComponent.sh:
  - Shell scripts for calculating the NCD between instances
  - Assumes:
    - saveAsBinary has been run
    - suitable compressors are on the file system

compareDjToNCD.m:
  - Creates plots for comparing the J-divergence results to the NCD results
  
plotNCDResults.m:
  - Script for plotting the NCD visualisations, heatmaps and dendrograms

[1] R. Morgan. Analysing and Comparing Problem Landscapes for Black-Box Optimization via Length Scale. PhD thesis, The University of Queensland, 2015.