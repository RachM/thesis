% Script for calculating the length scales and saving as binary files
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
addpath(genpath('../COMMON'));
clc;
clear all;

ell = 1:0.25:10;
dim = 2;
precision = 10^(-3);
dirName = 'data/';
bounds = [-1 1];
nSamples = 10^6; % To keep computational complexity tractable

seed = 401;
RandStream.setDefaultStream(RandStream('mt19937ar','seed',seed)); % So we can reproduce
initPoint = rand(1, dim) * range(bounds) + bounds(1);
x = randomLevyWalk(initPoint, nSamples, precision, bounds);

for i=1:length(ell)    
    f = ellipse(x, ell(i));
    
    ind1 = randperm(nSamples);
    ind2 = [ind1(2:end),ind1(1)];
    r = sort((abs(f(ind1) - f(ind2)) ./ sqrt(sum((x(ind1, :) - x(ind2, :)).^2, 2))));
    
    fid = fopen([dirName, 'e', num2str(ell(i)), '.bin'], 'w+');
    fwrite(fid, r, 'double', 0, 'l');
    fclose(fid);
    
    disp(['Finished Ellipse: ', num2str(ell(i))]);
end

for i=1:(length(ell)-1)
    fid = fopen([dirName, 'e', num2str(ell(i)), '.bin']);
    ls1 = fread(fid, inf, 'double', 0, 'l');
    fclose(fid);

    for j=(i+1):length(ell)
        
        fid = fopen([dirName, 'e', num2str(ell(j)), '.bin']);
        ls2 = fread(fid, inf, 'double', 0, 'l');
        fclose(fid);

        ls = sort([ls1; ls2]);
        clear ls2;

        fid = fopen([dirName, 'e', num2str(ell(i)), '_e', num2str(ell(j)), '.bin'], 'w+');
        fwrite(fid, ls, 'double', 0, 'l');
        fclose(fid);
    end
        
    disp(['Finished Combined Ellipse: ', num2str(ell(i))]);
end