function [ dist ] = distanceMaximimum( points )
% Calculates the maximum distance described in [1].
% NOTE: rounding occurs BEFORE the max is taken
%
% [1] Reinelt, G. TSPLIB95, 1995.
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

[n d] = size(points);
dist = zeros(n);
for i=1:n-1
    for j=i+1:n
        dist(i,j) = max(round(abs(points(i,:) - points(j,:))));
    end
end

end

