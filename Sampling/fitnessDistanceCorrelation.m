function [ r ] = fitnessDistanceCorrelation(x, f, globalX, p)
% Calculates fitness distance correlation from sample of data
% Taken from Terry Jones' Thesis (page 134)
% Arguments:
%           x: n x dim search points visited (rows are points, cols are dimension)
%           f: n x 1 vector of fitness values of the points visited
%           globalX: 1 x dim vector of the point of the global max / min
%           p: p in the Lp norm
% Returns:
%           r: fitness distance correlation coefficient
%
% IMPORTANT: if doing maximisation, want r = -1 (perfect correlation)
%            if doing minimisation, want r = 1 (perfect correlation)
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

[row col] = size(x);

d = pdist2(globalX, x, 'minkowski', p);
d = min(d, [], 1);

fMean = mean(f);
dMean = mean(d);

c = sum((f' - fMean) .* (d - dMean)) / row;
r = c ./ (std(f) * std(d));

end

