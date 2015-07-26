function [ disp ] = dispersion(x, f, sB, p)
% Calculates dispersion from sample of data.
% Taken from 'The Dispersion Metric and the CMA Evolution Strategy'
% NOTE: Assumes minimisation.
% Arguments:
%           x: n x dim search points visited (rows are points, cols are dimension)
%           f: fitness values of the points visited
%           sB: number of 'best' sample points to take (0 < sB <= n)
%           p: p in the Lp norm
%
% Returns:
%           dispersion: the average pairwise distance of the best points
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

[fTemp indices] = sort(f); % Assumes minimisation
bestIndices = indices(1:sB);
disp = mean(pdist(x(bestIndices, :), 'minkowski', p));

end