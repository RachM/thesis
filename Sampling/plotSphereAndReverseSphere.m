% Script for plotting the dispersion and FDC of the Sphere and Reverse
% Spere functions. The metrics are calculated using a uniform random walk
% with Lp norms p = 0.1, 0.5, 1 and 2, as well as a fixed step walk and
% Levy random walk.
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

dirName = 'data/';

load([dirName, 'sphere_and_reverse_sphere_samples.mat']);

figure;
hold on;
xlabel('Dimension', 'FontSize', 18);
ylabel('FDC', 'FontSize', 18);

type = fixed; % Change this to whatever metric you are interested in
fdc = type.fdc;
fdcEst = type.fdc;
dispersion = type.dispersion;

dimInd = 1:length(dim);

% Normalise dispersion by sqrt(dimension)
[n1 n2 n3] = size(dispersion);
c = sqrt(dim)';
denom = repmat(c, [1, n2, n3]);
dispersion = dispersion ./ denom;

indSphere = 1;
indRSphere = 2;

errorbar(dimInd, mean(fdc(dimInd, indSphere, ind), 3), std(fdc(dimInd, indSphere, ind), [], 3), 'b-')
errorbar(dimInd, mean(fdcEst(dimInd, indSphere, ind), 3), std(fdcEst(dimInd, indSphere, ind), [], 3), 'b:')
errorbar(dimInd, mean(fdc(dimInd, indRSphere, ind), 3), std(fdc(dimInd, indRSphere, ind), [], 3), 'r-')
errorbar(dimInd, mean(fdcEst(dimInd, indRSphere, ind), 3), std(fdcEst(dimInd, indRSphere, ind), [], 3), 'r:')

h = legend('$f_S = FDC_{x^*}$', '$f_S = FDC_{\hat{x}^*}$', '$f_{RS} = FDC_{x^*}$', '$f_{RS} = FDC_{\hat{x}^*}$')
set(h, 'Interpreter', 'latex')

set(gca, 'XScale', 'log')
set(gca, 'FontSize', 14);
axis([2 200 -0.5 1])

figure;
hold on;
xlabel('Dimension', 'FontSize', 18);
ylabel('Dispersion', 'FontSize', 18);
errorbar(dimInd, mean(dispersion(dimInd, indSphere, ind), 3), std(dispersion(dimInd, indSphere, ind), [], 3), 'b-')
errorbar(dimInd, mean(dispersion(dimInd, indRSphere, ind), 3), std(dispersion(dimInd, indRSphere, ind), [], 3), 'r-')
h = legend('$f_S', '$f_{RS}$')
set(h, 'Interpreter', 'latex')
set(gca, 'XScale', 'log')
set(gca, 'FontSize', 14);
axis([2 200 0 1])

% Uncomment for bound normalised
% c = range(bounds);
% load([dirName, 'distance_ratio.mat']);
% dispSphere = unif.lp.dispersion(:, 1, :, end);
% dispSphere = reshape(dispSphere, length(dim), seeds);
% dispSphere = (dispSphere - distMin) ./ (distMax - distMin) ./ c;
% dispRSphere = unif.lp.dispersion(:, 2, :, end);
% dispRSphere = reshape(dispRSphere, length(dim), seeds);
% dispRSphere = (dispRSphere - distMin) ./ (distMax - distMin) ./ c;
% figure;
% hold on;
% xlabel('Dimension', 'FontSize', 18);
% ylabel('Dispersion', 'FontSize', 18);
% errorbar(dimInd, mean(dispSphere(dimInd, ind), 2), std(dispSphere(dimInd, ind), [], 2), 'b-')
% errorbar(dimInd, mean(dispRSphere(dimInd, ind), 2), std(dispRSphere(dimInd, ind), [], 2), 'r-')
% h = legend('$f_S', '$f_{RS}$')
% set(h, 'Interpreter', 'latex')
% set(gca, 'XScale', 'log')
% set(gca, 'FontSize', 14);
% axis([2 200 0 1])   