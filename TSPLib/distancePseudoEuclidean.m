function [ dist ] = distancePseudoEuclidean( points )
% Calculates the pesudo-Euclidean distance described in [1].
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
for i=1:n
    for j=1:n
        temp = points(i,:) - points(j,:);
        r = sqrt(sum(temp.*temp) / 10);
        t = round(r);
        
        dist(i,j) = t;
        if (t < r)
            dist(i,j) = t + 1;
        end
    end
end

end

