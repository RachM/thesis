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

dirName = 'data/';
dim = 10;
nSamples = 2.5 * (10^5) * (dim^2); % To keep computational complexity tractable
problems = {@griewank, @michalewicz, @rastrigin, @rosenbrock};
bounds = [-5.12, 5.12; -5, 5; -5, 5; -600, 600; 0 pi]; % Bounds for each problem
seedBase = 700;
walks = 1:30;

for i=1:length(problems)
    RandStream.setDefaultStream(RandStream('mt19937ar', 'seed', seedBase + i)); % So we can reproduce
    bound = bounds(i, :);
    precision = 10^(-3) * 2 / range(bound);
    initPoint = rand(1, dim) * range(bound) + bound(1);
    x = randomLevyWalk(initPoint, nSamples, precision, bound);
    func = problems{i};
    f = func(x);
        
    for j=1:length(walks)
        ind1 = randperm(nSamples);
        ind2 = [ind1(2:end), ind1(1)];
        r = sort((abs(f(ind1) - f(ind2)) ./ sqrt(sum((x(ind1, :) - x(ind2, :)).^2, 2))));

        fid = fopen([dirName, func2str(func), '/walk', num2str(walks(j)), '.bin'], 'w+');
        fwrite(fid, r, 'double', 0, 'l');
        fclose(fid);
    end    
    disp(['Finished ', func2str(func)]);
end

for i=1:length(problems)
    func = problems{i};
    for j=1:length(walks)
        fid = fopen([dirName, func2str(func), '/walk', num2str(walks(j)), '.bin']);
        ls1 = fread(fid, inf, 'double', 0, 'l');
        fclose(fid);
                
        for k=1:length(walks)
            fid = fopen([dirName, func2str(func), '/walk', num2str(walks(k)), '.bin']);
            ls2 = fread(fid, inf, 'double', 0, 'l');
            fclose(fid);

            ls = [ls1; ls2];
            clear ls2;

            fid = fopen([dirName, func2str(func), '/walk', num2str(walks(j)), '_walk', num2str(walks(k)), '.bin'], 'w+');
            fwrite(fid, ls, 'double', 0, 'l');
            fclose(fid);
        end
    disp(['Finished Walks: ', num2str(walks(j))]);
    end
end