% Script for generating the Number Partitioning problems and calculating the length scales between the problems.
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

n = 20;
xOrig = dec2bin(1:2^(n - 1), n);
xOrig = xOrig - '0';
xOrig(end, :) = zeros(1, n);
nUniqueSolutions = size(xOrig, 1);

k = 0.4:0.025:1.3;
nTrials = 1:10;
nLengthScales = size(xOrig, 1);
nKernel = 1000;
deltaX = zeros(length(nTrials), length(k), nLengthScales);
bandwidths = zeros(length(nTrials), length(k), 1);
pKernel = zeros(length(nTrials), length(k), nKernel);
xKernel = zeros(length(nTrials), length(k), nKernel);

seed = 601;

for t=1:length(nTrials)
    RandStream.setDefaultStream(RandStream('mt19937ar','seed', seed + nTrials(t))); % So we get different rand 
    for j=1:length(k)
        M = 2^(k(j) * n);
        A = ceil(rand(1, n) * M); % Integers drawn uniformly from {1, 2, ..., M}
        A = repmat(A, nUniqueSolutions + 1, 1);
        
        ind = randperm(nUniqueSolutions);
        x = xOrig(ind, :);
        x = [x; x(1, :)];
        
        s1 = sum(A .* x, 2);
        s2 = sum(A .* (1 - x), 2);
        f = max(s1, s2);
        
        deltaX = sum((x(2:end, :) - x(1:end - 1, :)) ~= 0, 2)';        
        deltaF = abs(f(2:end) - f(1:end - 1));
        clear f;
        
        lengthScales = deltaF ./ deltaX;        
        lengthScales = sort(lengthScales);
        
        fid = fopen(['data/trial',num2str(nTrials(t)),'/','k',num2str(k(j)),'.bin'], 'w+');
        fwrite(fid, lengthScales, 'double', 0, 'l');
        fclose(fid);    
        
        disp([num2str(length(k) - j),' left...']);
    end
    disp(['Finished trial: ',num2str(nTrials(t))]);
end
