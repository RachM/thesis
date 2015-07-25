CompressorInvestigation
====

Source for calculating the length scales and compression ratios. Used in the experiments in Section 8.2.2 of [1].

To use:

analyseConcatenated.m:
  - Script for calculating compressor properties for concatenated datasets

analyseSingle.m:
  - Script for calculating compressor properties for single datasets

calculateLengthScalesAndSaveAsBinary.m:
  - Script for calculating the length scales and saving as binary files

compressEmpty.sh, compressSingle.sh and compressConcatenated:
  - Shell script for compressing various datasets
  - Assumes:
    - calculateLengthScalesAndSaveAsBinary has been run
    - suitable compressors are on the file system

[1] R. Morgan. Analysing and Comparing Problem Landscapes for Black-Box Optimization via Length Scale. PhD thesis, The University of Queensland, 2015.