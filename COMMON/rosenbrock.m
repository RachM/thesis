function [ f ] = rosenbrock( x )
% Calculates the objective function of the Rosenbrock function.
%
% Assumes:
%   - x: nPoints x dim matrix, where nPoints: number of solutions
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

if size(x,2) < 2
    disp('Dimensionality must be 2 or larger.');
    return;
end

f = sum(100 * ((x(:, 2:end) - x(:, 1:end - 1).^2).^2) + (1 - x(:, 1:end - 1)).^2, 2);

end

