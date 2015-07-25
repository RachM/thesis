function [ cost ] = calculateCost( dist, tour )
% Calculates the round-trip cost of a tour
% Inputs:
%   dist: n x n distance matrix
%   tour: 1 x n tour
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

n = length(tour);
cost = dist(tour(n),tour(1)); % round trip
for i=1:(n-1)
    cost = cost + dist(tour(i),tour(i+1));
end

end