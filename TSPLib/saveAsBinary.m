% Saves the TSPLib length scales as binary files in order to perform NCD
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

dirName = 'data/';
fileNames = {...
    'Symmetric_kroA100','Symmetric_kroB100','Symmetric_kroC100','Symmetric_kroD100',...
    'Symmetric_kroE100','Symmetric_bayg29','Symmetric_bays29','Symmetric_gr17', 'Symmetric_gr21',...
    'Symmetric_gr24', 'Symmetric_gr48', 'Symmetric_ulysses16', 'Symmetric_ulysses22', ...
    ...
    'Asymmetric_br17','Asymmetric_ft53','Asymmetric_ft70','Asymmetric_ftv33','Asymmetric_ftv35',...
    'Asymmetric_ftv38', 'Asymmetric_ftv44', 'Asymmetric_ftv47', 'Asymmetric_ftv55', 'Asymmetric_ftv64', ...
    'Asymmetric_p43', 'Asymmetric_ry48p', 'Asymmetric_kro124p'...
    };

for i=1:length(fileNames)
    fid = fopen([dirName,fileNames{i},'.bin']);
    ls1 = fread(fid, inf, 'double', 0, 'l');
    fclose(fid);
    
    ls = sort([ls1; ls1]);
    
    fid = fopen([dirName,fileNames{i},'_',fileNames{i},'.bin'], 'w+');
    fwrite(fid, ls, 'double', 0, 'l');
    fclose(fid);

    for j=i+1:length(fileNames)
        
        fid = fopen([dirName,fileNames{j},'.bin']);
        ls2 = fread(fid, inf, 'double', 0, 'l');
        fclose(fid);

        ls = sort([ls1; ls2]);
        clear ls2;

        fid = fopen([dirName,fileNames{i},'_',fileNames{j},'.bin'], 'w+');
        fwrite(fid, ls, 'double', 0, 'l');
        fclose(fid);
    end
    
    disp(['Finished: ',fileNames{i}]);
end