Sampling
====

Source for calculating the dispersion and fitness distance correlation using various sampling techniques. Used in the experiments in Chapter 4 of [1].

To use:

calculateDistanceRatio.m:
  - Script for calculating the distance ratio. Used in Section 4.2 of [1]

calculateMetricsBBOB.m
  - Script for calculating the dispersion and FDC of the BBOB functions. The metrics are calculated using a uniform random walk with Lp norms p = 0.1, 0.5, 1 and 2, as well as a fixed step walk and Levy random walk

calculateMetricsSphereAndReverseSphere.m
  - Script for calculating the dispersion and FDC of the Sphere and Reverse Sphere functions. The metrics are calculated using a uniform random walk with Lp norms p = 0.1, 0.5, 1 and 2, as well as a fixed step walk and Levy random walk

dispersion.m:
  - Calculates the dispersion of a given sample, using the Lp norm
  - Implemented based on [2]

fitnessDistanceCorrelation.m:
  - Calculates fitness distance correlation from sample of data, using the Lp norm
  - Implemented based on [3]

plotBBOB.m:
  -  Script for plotting the dispersion and FDC of the Sphere and Reverse Spere functions. The metrics are calculated using a uniform random walk with Lp norms p = 0.1, 0.5, 1 and 2, as well as a fixed step walk and Levy random walk

plotBBOBBoundNormalised.m:
  - Script for plotting the bound normalised dispersion of the BBOB functions

plotSphereAndReverseSphere.m:
  -  Script for plotting the dispersion and FDC of the BBOB functions.  The metrics are calculated using a uniform random walk with Lp norms p = 0.1, 0.5, 1 and 2, as well as a fixed step walk and Levy random walk.

[1] R. Morgan. Analysing and Comparing Problem Landscapes for Black-Box Optimization via Length Scale. PhD thesis, The University of Queensland, 2015.

[2] M. Lunacek and D. Whitley. The dispersion metric and the CMA evolution strategy. In Proceedings of the Genetic and Evolutionary Computation Conference (GECCO’06), pages 477–484, New York, USA, 2006. ACM.

[3] T. Jones. Evolutionary algorithms, fitness landscapes and search. PhD thesis, The University of New Mexico, 1995.