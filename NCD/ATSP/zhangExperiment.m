% Script for producing Zhang's (2004) results.
% W. Zhang. Phase transitions and backbones of the asymmetric traveling
% salesman problem. Journal of Artificial Intelligence Research, 
% 21(1):471–497, 2004.
%
% Assumptions:
%       - Data is in 'data/trialX' directory, where X is the trial number
%       - COMMON directory is local
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
clear all;
clc;

nTrials = 1;
b = 0.5:0.1:6.5;
nUnique = zeros(length(nTrials), length(b));
nUniqueStd = zeros(length(nTrials), length(b));
seed = 900;
n=10;

% Determine number of unique distances
for k=1:length(nTrials)
    RandStream.setDefaultStream(RandStream('mt19937ar','seed', seed + nTrials(k))); % So we get different rand 
    for j=1:length(b)
        R = floor(10^b(j));
        D = floor(rand(n) * R); % generates uniform random integers in [0,R-1]
        D(logical(eye(n))) = 0; % set the diagonal as 0
        freq = tabulate(reshape(D, 1, n^2));
        uniqueTemp = sum(freq(:, 2) == 1); % Unique values have only 1 occurrence
        nUnique(k, j) = sum(freq(:, 2) == 1); % average
    end
end

% Plot effective number of digits vs fraction of distinct distances
figure;
hold on;
xlabel('b', 'FontSize', 18);
ylabel('Fraction of Distinct Numbers', 'FontSize', 18);
nEffective = b ./ log10(n);
m = mean(nUnique, 1) ./ (n^2 - n);
v = std(nUnique, [] ,1) ./ (n^2 - n);
errorbar(nEffective, m, v, 'Color', 'k', 'LineWidth', 1);
set(gca, 'FontSize', 14);
axis([0 6.5 0 1]);