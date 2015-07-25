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
clear all;
clc;

dim = 1:15;
dirName = 'data/';
bounds = [-600, 600];
precision = 0.5;

seed = 501;
RandStream.setDefaultStream(RandStream('mt19937ar', 'seed', seed + dim(i))); % So we can reproduce

for i=1:length(dim)
    nSamples = 2.5 * (10^5) * (dim(i)^2); % To keep computational complexity tractable
    initPoint = rand(1, dim(i)) * range(bounds) + bounds(1);
    x = randomLevyWalk(initPoint, nSamples, precision, bounds);    
    f = griewank(x);
        
    ind1 = randperm(nSamples);
    ind2 = [ind1(2:end), ind1(1)];
    r = sort((abs(f(ind1) - f(ind2)) ./ sqrt(sum((x(ind1, :) - x(ind2, :)).^2, 2))));
    
    fid = fopen([dirName, 'd', num2str(dim(i)), '.bin'], 'w+');
    fwrite(fid, r, 'double', 0, 'l');
    fclose(fid);
    
    disp(['Finished Griewank D: ', num2str(dim(i))]);
end

for i=1:(length(dim)-1)
    fid = fopen([dirName, 'd', num2str(dim(i)), '.bin']);
    ls1 = fread(fid, inf, 'double', 0, 'l');
    fclose(fid);
    
    ls = sort([ls1; ls1]);
    fid = fopen([dirName, 'd', num2str(dim(i)), '_d',num2str(dim(i)), '.bin'], 'w+');
    fwrite(fid, ls, 'double', 0, 'l');
    fclose(fid);

    for j=(i+1):length(dim)        
        fid = fopen([dirName, 'd', num2str(dim(j)), '.bin']);
        ls2 = fread(fid, inf, 'double', 0, 'l');
        fclose(fid);

        ls = sort([ls1; ls2]);
        clear ls2;

        fid = fopen([dirName, 'd', num2str(dim(i)), '_d', num2str(dim(j)), '.bin'], 'w+');
        fwrite(fid, ls, 'double', 0, 'l');
        fclose(fid);
    end
        
    disp(['Finished Combined Griewank D: ', num2str(dim(i))]);
end

seed = 5001;

for i=1:length(dim)
    RandStream.setDefaultStream(RandStream('mt19937ar', 'seed', seed + dim(i))); % So we can reproduce
    nSamples = 2.5 * (10^5) * (dim(i)^2); % To keep computational complexity tractable
    initPoint = rand(1, dim(i)) * range(bounds) + bounds(1);
    x = randomLevyWalk(initPoint, nSamples, precision, bounds);
    
    f = 1 + (1 / 4000) * sum(x.^2, 2); % Qudratic term
        
    ind1 = randperm(nSamples);
    r = (abs(f(ind1) - f([ind1(2:end), ind1(1)])) ./ sqrt(sum((x(ind1, :) - x([ind1(2:end), ind1(1)], :)).^2, 2)));
    clear x f ind1;
    r = sort(r);
    
    fid = fopen([dirName, 'c', num2str(dim(i)), '.bin'], 'w+');
    fwrite(fid, r, 'double', 0, 'l');
    fclose(fid);
    
    disp(['Finished Griewank D: ', num2str(dim(i))]);
end

for i=1:(length(dim)-1)
    fid = fopen([dirName, 'c', num2str(dim(i)), '.bin']);
    ls1 = fread(fid, inf, 'double', 0, 'l');
    fclose(fid);

    ls = sort([ls1; ls1]);
    
    fid = fopen([dirName, 'c', num2str(dim(i)), '_c', num2str(dim(i)), '.bin'], 'w+');
    fwrite(fid, ls, 'double', 0, 'l');
    fclose(fid);
    
    for j=(i+1):length(dim)        
        fid = fopen([dirName, 'c', num2str(dim(j)), '.bin']);
        ls2 = fread(fid, inf, 'double', 0, 'l');
        fclose(fid);

        ls = sort([ls1; ls2]);
        clear ls2;

        fid = fopen([dirName, 'c', num2str(dim(i)), '_c', num2str(dim(j)), '.bin'], 'w+');
        fwrite(fid, ls, 'double', 0, 'l');
        fclose(fid);
    end
        
    disp(['Finished Combined Griewank D: ', num2str(dim(i))]);
end

for i=1:length(dim)
    fid = fopen([dirName, 'd', num2str(dim(i)), '.bin']);
    ls1 = fread(fid, inf, 'double', 0, 'l');
    fclose(fid);

    for j=1:length(dim)        
        fid = fopen([dirName, 'c', num2str(dim(j)), '.bin']);
        ls2 = fread(fid, inf, 'double', 0, 'l');
        fclose(fid);

        ls = sort([ls1; ls2]);
        clear ls2;

        fid = fopen([dirName, 'd', num2str(dim(i)), '_c', num2str(dim(j)), '.bin'], 'w+');
        fwrite(fid, ls, 'double', 0, 'l');
        fclose(fid);
    end
        
    disp(['Finished Combined Griewank D: ', num2str(dim(i))]);
end