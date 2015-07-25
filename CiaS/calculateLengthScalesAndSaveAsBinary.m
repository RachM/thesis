% Script for calculating the length scales and saving as binary files
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

circles = 2:100;
dim = 2;
precision = 10^(-3) / 2;
dirName = 'data/';
dirName2 = 'data_nonsorted/';
bounds = [0 1];
nSamplesBase = 2.5 * 10^5;
seed = 300;

for i=1:length(circles)    
    nSamples = nSamplesBase * (circles(i) * dim);
    RandStream.setDefaultStream(RandStream('mt19937ar','seed', seed + circles(i))); % So we can reproduce
    initPoint = rand(1, dim * circles(i)) * range(bounds) + bounds(1);
    x = randomLevyWalk(initPoint, nSamples, precision, bounds);
    f = zeros(nSamples, 1);
    inds = randperm(nSamples);
    x = x(inds, :);
    clear inds;
    for k=1:nSamples
        x_temp = reshape(x(k,:), circles(i), dim);
        f(k) = min(pdist(x_temp)); % objective function is min parwise distances
    end
    
    r = sort((abs(f(2:nSamples) - f(1:nSamples-1)) ./ sqrt(sum((x(2:nSamples, :) - x(1:nSamples-1, :)).^2, 2))));
    
    fid = fopen([dirName, 'c', num2str(circles(i)), '.bin'], 'w+');
    fwrite(fid, r, 'double', 0, 'l');
    fclose(fid);
    
    disp(['Finished Circle: ', num2str(circles(i))]);
end

circles = 2:30; % Only do 30 circles in NCD experiments
for i=1:length(circles)
    fid = fopen([dirName, 'c', num2str(circles(i)), '.bin']);
    ls1 = fread(fid, inf, 'double', 0, 'l');
    fclose(fid);

    for j=i:length(circles)        
        fid = fopen([dirName, 'c', num2str(circles(j)), '.bin']);
        ls2 = fread(fid, inf, 'double', 0, 'l');
        fclose(fid);

        ls = sort([ls1; ls2]);
        clear ls2;

        fid = fopen([dirName2,'c',num2str(circles(i)),'_c',num2str(circles(j)),'.bin'], 'w+');
        fwrite(fid, ls, 'double', 0, 'l');
        fclose(fid);
    end
        
    disp(['Finished Combined Circles: ', num2str(circles(i))]);
end