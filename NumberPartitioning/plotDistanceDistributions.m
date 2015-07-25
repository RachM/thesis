% Script for plotting the distance distributions. See Section 7.6.1 of [1]
%
% [1] R. Morgan. Analysing and Comparing Problem Landscapes for Black-Box
% Optimization via Length Scale. PhD thesis, The University of Queensland, 2015.
% 
% Copyright (C) 2015 Rachael Morgan (rachael.morgan8@gmail.com)
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
addpath(genpath('../COMMON'));
clear all;
clc;

load('hamming_distance_distributions.mat');
p = reshape(pHist, 10*37 ,19);
figure;
fontSize = 18;
boxplot(p);
xlabel('Hamming Distance', 'FontSize', fontSize);
ylabel('Probability', 'FontSize', fontSize);