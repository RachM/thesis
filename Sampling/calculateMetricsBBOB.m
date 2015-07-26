% Script for calculating the dispersion and FDC of the BBOB functions.
% The metrics are calculated using a uniform random walk
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
bounds = [-5, 5];
precisionFixed = (10^-1) * range(bounds);
precisionLevy = (10^-2) * range(bounds);
dispersionThreshold = 0.05;
fn = 1:24;
seeds = 1:30;
lpValues = [0.1, 0.5, 1, 2];
fhs = benchmarks('handles');
seedBase = 10000;

dim = [1:50, 100, 150, 200];
save([dirName,'bbob_samples.mat'], 'dim', 'bounds', 'fn', 'precisionFixed', 'precisionLevy', ...
    'dispersionThreshold', 'seeds', 'seedBase', 'lpValues', 'unif', 'levy', 'fixed');

levy = struct();
levy.fdcEst = zeros(length(dim), length(fn), length(seeds));
levy.fdc = zeros(length(dim), length(fn), length(seeds));
levy.dispersion = zeros(length(dim), length(fn), length(seeds));
levy.distances = struct([]);

unif = struct;
unif.lp = struct;
unif.lp.fdcEst = zeros(length(dim), length(fn), length(seeds), length(lpValues));
unif.lp.fdc = zeros(length(dim), length(fn), length(seeds));
unif.lp.dispersion = zeros(length(dim), length(fn), length(seeds));

fixed = struct();
fixed.fdcEst = zeros(length(dim), length(fn), length(seeds));
fixed.fdc = zeros(length(dim), length(fn), length(seeds));
fixed.dispersion = zeros(length(dim), length(fn), length(seeds));
fixed.distances = struct([]);

for dInd=1:length(dim)
    nSamples = 1000 * dim(dInd);
    seed = seedBase + dim(dInd);
    RandStream.setDefaultStream(RandStream('mt19937ar', 'seed', seed)); % So we can reproduce
    
    xInit = rand(1, dim(dInd)) * range(bounds) + bounds(1);
    xF = randomFixedWalk(xInit, nSamples, precisionFixed, bounds);
    xL = randomLevyWalk(xInit, nSamples, precisionLevy, bounds);
    xU = rand(nSamples, dim(dInd)) * range(bounds) + min(bounds);
    xU(1, :) = xInit;
    
%     d = pdist(xU);
%     unif.distances{dInd}.minD = min(d);
%     unif.distances{dInd}.maxD = max(d);
%     unif.distances{dInd}.stdD = std(d);
%     unif.distances{dInd}.meanD = mean(d);
%     
%     d = pdist(xL);
%     levy.distances{dInd}.minD = min(d);
%     levy.distances{dInd}.maxD = max(d);
%     levy.distances{dInd}.stdD = std(d);
%     levy.distances{dInd}.meanD = mean(d);
%     
%     d = pdist(xF);
%     fixed.distances{dInd}.minD = min(d);
%     fixed.distances{dInd}.maxD = max(d);
%     fixed.distances{dInd}.stdD = std(d);
%     fixed.distances{dInd}.meanD = mean(d);

    for fInd=1:length(fn)
        func = fhs{fn(fInd)};
        
        for sInd=1:length(seeds)
            [fG xG] = func('xopt', dim(dInd), seeds(sInd));
            xG = xG';

            % Uniform random
            f = func(xU', [], seeds(sInd))';
            [fGEst minInd] = min(f);
            xGEst = xU(minInd,:);
            xt = [xU(1:(minInd - 1), :); xU((minInd + 1):end, :)];
            ft = [f(1:(minInd - 1)); f((minInd + 1):end)];        
            
            for p=1:length(lpValues)-1
                unif.lp.fdcEst(dInd, fInd, sInd, p) = fitnessDistanceCorrelation(xt, ft, xGEst, lpValues(p));
                unif.lp.fdc(dInd, fInd, sInd, p) = fitnessDistanceCorrelation(xt, ft, xG, lpValues(p));
                unif.lp.dispersion(dInd, fInd, sInd, p) = dispersion(xU, f, round(dispersionThreshold * nSamples), lpValues(p));
            end           

            % Random Levy Walk
            f = func(xL', [], seeds(sInd))';
            [fGEst minInd] = min(f);
            xGEst = xL(minInd,:);
            xt = [xL(1:(minInd-1),:); xL((minInd+1):end, :)];
            ft = [f(1:(minInd-1)); f((minInd+1):end)];            
            levy.fdcEst(dInd, fInd, sInd) = fitnessDistanceCorrelation( xt, ft, xGEst );
            levy.fdc(dInd, fInd, sInd) = fitnessDistanceCorrelation( xt, ft, xG );
            levy.dispersion(dInd, fInd, sInd) = dispersion(xL, f, round(dispersionThreshold*nSamples));

            % Random Walk (fixed step)
            f = func(xF', [], seeds(sInd))';
            [fGEst minInd] = min(f);
            xGEst = xF(minInd,:);
            xt = [xF(1:(minInd-1),:); xF((minInd+1):end, :)];
            ft = [f(1:(minInd-1)); f((minInd+1):end)];            
            fixed.fdcEst(dInd, fInd, sInd) = fitnessDistanceCorrelation( xt, ft, xGEst );
            fixed.fdc(dInd, fInd, sInd) = fitnessDistanceCorrelation( xt, ft, xG );
            fixed.dispersion(dInd, fInd, sInd) = dispersion(xF, f, round(dispersionThreshold*nSamples));
        end
    save([dirName,'bbob_samples.mat'], 'unif', 'fixed', 'levy', '-append');
    end
    disp(['Finished D', num2str(dim(dInd))]);
end
