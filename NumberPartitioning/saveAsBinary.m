% Saves the Number Partitioning length scales as binary files in order to perform NCD
% Assumptions:
%       - Data is in 'data/trialX' directory, where X is the trial number
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

% Settings
n = 20;
k = 0.4:0.025:1.3;
trials = 1:10;

for t=1:length(trials)
    dirName = ['data/trial', num2str(trials(t)), '/'];

    for i=1:length(k)
        fid = fopen([dirName, 'k', num2str(k(i)), '.bin']);
        ls1 = fread(fid, inf, 'double', 0, 'l');
        fclose(fid);

        for p=(i+1):length(k)
            fid = fopen([dirName, 'k', num2str(k(p)), '.bin']);
            ls2 = fread(fid, inf, 'double', 0, 'l');
            fclose(fid);

            ls = sort([ls1; ls2]);
            clear d2;

            fid = fopen([dirName, 'k', num2str(k(i)), '_k', num2str(k(p)), '.bin'], 'w+');
            fwrite(fid, ls, 'double', 0, 'l');
            fclose(fid);
        end
        disp(['Finished: ', num2str(k(i))]);
    end
end
