Ellipse
====

Source for calculating the length scales, Dj and NCD between Elliptical function instances. Also compares the NCD results to the J-divergence results. Used in the experiments in Sections 7.1.1, 8.3.1 and 8.4.2 of [1].

To use:

calculateCorrelationWithERT.m:
  - Script for calculating the correlation between each metric and the best ERT

calculateDistributionsAndKL.m:
  - Script for calculating the length scale distributions and KL divergence

calculateDistributionsAndKLBetweenD.m:
  - Calculates the length scale distributions and KL divergence between BBOB problems of different dimensions

calculateLengthScalesAndSaveAsBinary.m:
  - Script for calculating the length scales and saving as binary files. This is used in computation of the NCD

calculateMetrics.m:
  - Script for calculating landscape metrics of the BBOB problems

calculateNCD.sh:
  - Shell script for calculating the NCD between instances of the same dimension
  - Assumes:
    - calculateLengthScalesAndSaveAsBinary has been run
    - suitable compressors are on the file system

calculateNCDBetweenD.sh:
  - Shell script for calculating the NCD between instances of different dimensions
  - Assumes:
    - calculateLengthScalesAndSaveAsBinary has been run
    - suitable compressors are on the file system

compareDjToNCD.m:
  - Creates plots for comparing the J-divergence results to the NCD results

plotDistributionsBetweenD.m:
  - Script for plotting the length scale distributions across dimensionality
  
plotDjResults.m:
  - Script for plotting the J-divergence visualisations, heatmaps and dendrograms

plotFeatureVectorSpace.m:
  - Script for plotting the visualisations, heatmaps and dendrograms of the landscape feature feature vector

plotMetricsVsERT.m:
  - Script for plotting landscape metrics against the best ERT
    
plotNCDResults.m:
  - Script for plotting the NCD visualisations, heatmaps and dendrograms

sampleBBOB.m:
  - Script for sampling the BBOB functions

[1] R. Morgan. Analysing and Comparing Problem Landscapes for Black-Box Optimization via Length Scale. PhD thesis, The University of Queensland, 2015.