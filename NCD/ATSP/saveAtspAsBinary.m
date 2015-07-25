% Saves the ATSP length scales as binary files in order to perform NCD
% Assumptions:
%       - Data is in 'data/trialX' directory, where X is the trial number
%       - COMMON directory is local
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
clear all;
clc;
load('data/length_scales.mat');

% Settings
n = 10;
b = 0.5:0.1:6.5;
trials = 1:10;

% Save single problem
for i=1:length(b)
    for j=1:length(trials)
        lsSample = sort(reshape(lengthScales(i, trials(j), :), nLengthScales,1));
        fid = fopen([dirName, 'b', num2str(b(i)), '_t', num2str(trials(j)), '.bin'], 'w+');
        fwrite(fid, lsSample, 'double', 0, 'l');
        fclose(fid);
    end
end

for t=1:length(trials)
    dirName = ['data/trial', num2str(trials(t)), '/'];

    % Save problem vs problem
    for i=1:length(b)
        fid = fopen([dirName, 'b', num2str(b(i)), '.bin']);
        ls1 = fread(fid, inf, 'double', 0, 'l');
        fclose(fid);
        for p=i:length(b)
            fid = fopen([dirName, 'b', num2str(b(p)), '.bin']);
            ls2 = fread(fid, inf, 'double', 0, 'l');
            fclose(fid);

            ls = sort([ls1; ls2]);
            clear d2;

            fid = fopen([dirName, 'b', num2str(b(i)), '_b',num2str(b(p)), '.bin'], 'w+');
            fwrite(fid, ls, 'double', 0, 'l');
            fclose(fid);
        end
        disp(['Finished: ', num2str(b(i))]);
    end
end