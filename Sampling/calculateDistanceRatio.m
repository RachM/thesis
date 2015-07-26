% Script for calculating the distance ratio. Used in Section 4.2 of [1].
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
clc;
clear all;

d = [1:50, 100, 150, 200];
nTrials = 1:30;

distMin = Inf .* ones(length(d), length(nTrials));
distMax = zeros(length(d), length(nTrials));

for i=1:length(d)
    nSamples = 1000 * d(i); % Change this to whatever you want
    for j=1:length(nTrials)                
        x = rand(nSamples, d(i)); % Uniform random in [0, 1]
        
        for k=1:nSamples
            dist = pdist2(x, x(k,:), 'euclidean', 'Smallest', 2);
            dist = max(dist); % Filter out zero (dist between point and itself)
            if (dist < distMin(i, j))
                distMin(i, j) = dist;
            end

            dist = pdist2(x, x(k,:), 'euclidean', 'Largest', 1);
            if (dist > distMax(i, j))
                distMax(i, j) = dist;
            end
        end
        
        save('distance_ratio.mat', 'distMin', 'distMax');
       
        clear x dist;
        disp(['Completed trial ', num2str(j)]);
    end
    disp(['Completed D ', num2str(d(i))]);
end