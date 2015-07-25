function f = rastrigin(x, varargin)
% Calculates the objective function of the Rastrigin function.
%
% Assumes:
%   - x: nPoints x dim matrix, where nPoints: number of solutions
%   - varargin: optional parameter A (default is 10)
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

dim = size(x, 2);
a = 10;
if (numel(varargin) > 0)
    a = varargin{1};
end

f = a * (dim - sum(cos(2 * pi * x), 2)) + sum(x.^2, 2); 

end