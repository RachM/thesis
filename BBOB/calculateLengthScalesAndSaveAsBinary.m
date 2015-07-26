% Script for calculating the length scales and saving as binary files
% This is used in computation of the NCD.
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

dim = 20;

RandStream.setDefaultStream(RandStream('mt19937ar', 'seed', dim)); % So we get different rand
 
dirName = ['data/', num2str(dim), 'D/'];

nSamples = 50000 * dim; % Constant
bounds = [-5, 5];

% Get points that will be common to all problems
seeds = 1;
fhs = benchmarks('handles');
bbob_i = 1:24;

for i=1:length(bbob_i)
    func = fhs{bbob_i(i)};
    
    x = rand(dim,nSamples) * range(bounds) + bounds(1);
    f = func(x, [], seeds);
    x = x';
            
    save([dirName, 'f', num2str(bbob_i(i)), '.mat'], 'x', 'f');
    
%     Length Scales
    dF = abs(f(2:nSamples) - f(1:nSamples-1))';
    dX = sqrt(sum((x_temp(2:nSamples, :) - x_temp(1:nSamples-1, :)).^2, 2));
    ls = dF ./ dX;
    clear dF dX x_temp f;

    fid = fopen([dirName, 'f', num2str(bbob_i(i)), '.bin'], 'w+');
    fwrite(fid, ls, 'double', 0, 'l');
    fclose(fid);
    clear x f;

end

for i=1:length(bbob_i)-1
    fid = fopen([dirName, 'f', num2str(bbob_i(i)), '.bin']);
    data1 = fread(fid, 'double', 0, 'l');
    fclose(fid);
    
    for j=i+1:length(bbob_i)
        fid = fopen([dirName, 'f',num2str(bbob_i(j)),'.bin']);
        data2 = fread(fid, 'double', 0, 'l');
        fclose(fid);
    
        t = sort([data1', data2']);

        fid = fopen([dirName, 'f', num2str(bbob_i(i)), '_f', num2str(bbob_i(j)), '.bin'], 'w+');
        fwrite(fid, t, 'double', 0, 'l');
        fclose(fid);
        
        clear t data2;
    end
    clear data1;
end