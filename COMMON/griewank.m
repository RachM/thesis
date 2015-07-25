function f = griewank( x )
% Calculates the objective function of the Griewank problem.
%
% Assumes:
%   - x: nSamples x dim matrix of solutions
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

[nSamples dim] = size(x);

sqrtTerm = repmat(sqrt(1:dim) ,nSamples, 1);
f = 1 + (1/4000) * sum(x.^2, 2) - prod(cos(x ./ sqrtTerm), 2);

end