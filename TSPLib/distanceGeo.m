function [ dist ] = distanceGeo( points )
% Calculates the geographical distance described in [1].
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

PI = 3.141592;
RRR = 6378.388;

degrees = floor(points);
minutes = points - degrees;

latLong = PI * (degrees + (5*minutes/3)) / 180; % n x [lat long]

for i=1:n
    for j=1:n
        q1 = cos(latLong(i,2) - latLong(j,2));
        q2 = cos(latLong(i,1) - latLong(j,1));
        q3 = cos(latLong(i,1) + latLong(j,1));

        dist(i,j) = floor(RRR * acos( 0.5*((1+q1)*q2 - (1-q1)*q3) ) + 1);
    end
end

end

