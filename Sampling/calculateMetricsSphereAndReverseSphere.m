% Script for calculating the dispersion and FDC of the Sphere and Reverse
% Sphere functions. The metrics are calculated using a uniform random walk
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
bounds = [-1, 1];
precisionFixed = (10^-2) * range(bounds);
precisionLevy = (10^-3) * range(bounds);
dispersionThreshold = 0.05;
lpValues = [0.1, 0.5, 1, 2];
seedBase = 12000;
seeds = 30;
coefficient = [1, -1]; % co-efficients for Sphere coefficienttion: f = coefficient * x^2;

dim = [1:50, 100, 150, 200];

levy = struct();
levy.fdcEst = zeros(length(dim), length(coefficient), length(seeds));
levy.fdc = zeros(length(dim), length(coefficient), length(seeds));
levy.dispersion = zeros(length(dim), length(coefficient), length(seeds));
levy.distances = struct([]);

unif = struct;
unif.lp = struct;
unif.lp.fdcEst = zeros(length(dim), length(coefficient), length(seeds), length(lpValues));
unif.lp.fdc = zeros(length(dim), length(coefficient), length(seeds));
unif.lp.dispersion = zeros(length(dim), length(coefficient), length(seeds));

fixed = struct();
fixed.fdcEst = zeros(length(dim), length(coefficient), length(seeds));
fixed.fdc = zeros(length(dim), length(coefficient), length(seeds));
fixed.dispersion = zeros(length(dim), length(coefficient), length(seeds));
fixed.distances = struct([]);

save([dirName,'sphere_and_reverse_sphere_samples.mat'], 'dim', 'bounds', 'precisionFixed', 'precisionLevy', ...
    'dispersionThreshold', 'seeds', 'seedBase', 'lpValues', 'unif', 'levy', 'fixed');

for dInd=1:length(dim)
    nSamples = 1000 * dim(dInd);
    seed = seedBase + dim(dInd);
    RandStream.setDefaultStream(RandStream('mt19937ar', 'seed', seed)); % So we can reproduce
    
    for sInd=1:seeds
        xInit = rand(1, dim(dInd)) * range(bounds) + bounds(1);
        xF = randomFixedWalk(xInit, nSamples, precisionFixed, bounds); % Fixed step walk
        xL = randomLevyWalk(xInit, nSamples, precisionLevy, bounds); % Levy walk
        xU = rand(nSamples, dim(dInd))*range(bounds) + min(bounds); % Uniform random
        xU(1,:) = xInit;

        for fInd=1:length(coefficient)
            if (coefficient(fInd) == 1)
                xG = zeros(1, dim(dInd)); % Global is [0]^D
            else
                % Closest hypercube corner to each point
                xG = (xU - min(bounds)) / range(bounds);
                xG = round(xG);
                xG(xG == 0) = -1;
            end

            % Uniform random
            f = coefficient(fInd) * sum(xU.^2, 2);
            [fGEst minInd] = min(f);
            xGEst = xU(minInd, :);
            xt = [xU(1:(minInd - 1), :); xU((minInd + 1):end, :)];
            ft = [f(1:(minInd - 1)); f((minInd + 1):end)];
            for p=1:length(lpValues)
                unif.lp.fdcEst(dInd, fInd, sInd, p) = fitnessDistanceCorrelation(xt, ft, xGEst, lpValues(p));
                unif.lp.fdc(dInd, fInd, sInd, p) = fitnessDistanceCorrelation(xt, ft, xG, lpValues(p));
                unif.lp.dispersion(dInd, fInd, sInd, p) = dispersion(xU, f, round(dispersionThreshold * nSamples), lpValues(p));
            end

            % Random Levy Walk
            f = coefficient(fInd) * sum(xL.^2, 2);
            [fGEst minInd] = min(f);
            xGEst = xL(minInd, :);
            xt = [xL(1:(minInd - 1), :); xL((minInd + 1):end, :)];
            ft = [f(1:(minInd - 1)); f((minInd + 1):end)];            
            levy.fdcEst(dInd, fInd, sInd) = fitnessDistanceCorrelation(xt, ft, xGEst, 2);
            levy.fdc(dInd, fInd, sInd) = fitnessDistanceCorrelation(xt, ft, xG, 2);
            levy.dispersion(dInd, fInd, sInd) = dispersion(xL, f, round(dispersionThreshold * nSamples), 2);

            % Random Walk (fixed step)
            f = coefficient(fInd) * sum(xF.^2, 2);
            [fGEst minInd] = min(f);
            xGEst = xF(minInd, :);
            xt = [xF(1:(minInd - 1),:); xF((minInd + 1):end, :)];
            ft = [f(1:(minInd - 1)); f((minInd + 1):end)];            
            fixed.fdcEst(dInd, fInd, sInd) = fitnessDistanceCorrelation(xt, ft, xGEst, 2);
            fixed.fdc(dInd, fInd, sInd) = fitnessDistanceCorrelation(xt, ft, xG, 2);
            fixed.dispersion(dInd, fInd, sInd) = dispersion(xF, f, round(dispersionThreshold * nSamples), 2);
        end

        % Save
        save([dirName, 'sphere_and_reverse_sphere_samples.mat'], 'unif', 'fixed', 'levy',  '-append');
        disp(['Finished D', num2str(dim(dInd)), ' S', num2str(sInd)]);
    end
end
