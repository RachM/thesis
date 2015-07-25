% Script for calculating compressor properties for single datasets
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
walks = 1:30;

problems = {'griewank', 'michalewicz', 'rastrigin', 'rosenbrock'};
compressors = {'lzma', 'ppmd', 'gzip', 'bzip2', 'fpc'};
origInd = 2;
lzmaInd = 3;
ppmdInd = 4;
gzipInd = 5;
bzip2Ind = 6;
fpcInd = 7;

ratioMean = zeros(length(problems), length(compressors));
ratioStd = zeros(length(problems), length(compressors));

for i=1:length(problems)
    sizes = load([dirName,problems{i},'/sizes_single.dat']);
    times = load([dirName,problems{i},'/time_single.dat']);

    ratio = sizes(:, lzmaInd:fpcInd) ./ repmat(sizes(:, origInd), 1, length(lzmaInd:fpcInd));
    
    ratioMean(i,:) = mean(ratio,1);
    ratioStd(i,:) = std(ratio);
end