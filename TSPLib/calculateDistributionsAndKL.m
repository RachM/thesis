% Script for calculating the length scale distributions and KL divergence.
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
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
addpath(genpath('../COMMON'));
clear all;
clc;

fileNames = {...
    'Symmetric_kroA100','Symmetric_kroB100','Symmetric_kroC100','Symmetric_kroD100',...
    'Symmetric_kroE100','Symmetric_bayg29','Symmetric_bays29','Symmetric_gr17', 'Symmetric_gr21',...
    'Symmetric_gr24', 'Symmetric_gr48', 'Symmetric_ulysses16', 'Symmetric_ulysses22', ...
    ...
    'Asymmetric_br17','Asymmetric_ft53','Asymmetric_ft70','Asymmetric_ftv33','Asymmetric_ftv35',...
    'Asymmetric_ftv38', 'Asymmetric_ftv44', 'Asymmetric_ftv47', 'Asymmetric_ftv55', 'Asymmetric_ftv64', ...
    'Asymmetric_p43', 'Asymmetric_ry48p', 'Asymmetric_kro124p'...
    };

dirName = 'data/';

nKernel = 1000;
pKernel = zeros(length(fileNames), nKernel);
xKernel = zeros(length(fileNames), nKernel);
bandwidths = zeros(length(fileNames));
save('densities.mat', 'pKernel', 'xKernel', 'bandwidths', 'nKernel');

for i=1:length(fileNames)
    fid = fopen([dirName, fileNames{i}, '.bin']);
    ls1 = fread(fid, inf, 'double', 0, 'l')';
    fclose(fid);
    
    ind = randperm(length(ls1));
    ind = ind(1:10000);
    
    % Make kernel density estimate
    bandwidths(i) = fast_univariate_bandwidth_estimate_STEPI(length(ind), ls1(ind), 10^(-3));
    [pKernel1 xKernel1] = ksdensity(ls1, 'width', bandwidths(i), 'npoints', nKernel);
    pKernel(i,:) = pKernel1;
    xKernel(i,:) = xKernel1;
    
    disp(['TSP: ', fileNames{i}]);
    save('densities.mat', 'pKernel', 'xKernel', 'bandwidths', '-append');
end

disp('Saved kernel density estimates');

kl = zeros(length(fileNames));

for i=1:length(fileNames)
    fid = fopen([dirName, fileNames{i}, '.bin']);
    ls1 = fread(fid, inf, 'double', 0, 'l')';
    fclose(fid);
    
    for j=i+1:length(fileNames)
        fid = fopen([dirName, fileNames{j}, '.bin']);
        ls2 = fread(fid, inf, 'double', 0, 'l')';
        fclose(fid);

        xi = union(xKernel(i,:), xKernel(j,:));
        
        p1 = ksdensity(ls1, xi, 'width', bandwidths(i), 'npoints', nKernel);
		p2 = ksdensity(ls2, xi, 'width', bandwidths(j), 'npoints', nKernel);
        
        kl1 = p1 ./ p2;
        ind = kl1~=0 & ~isinf(kl1) & ~isnan(kl1);
        kl1 = p1 .* log2(kl1);
        kl1(~ind) = 0;
        inc = xi(2:end) - xi(1:end-1);
        kl1 = sum(((kl1(2:end) + kl1(1:end - 1)) / 2) .* inc);

        kl2 = p2 ./ p1;
        ind = kl2~=0 & ~isinf(kl2) & ~isnan(kl2);
        kl2 = p2 .* log2(kl2);
        kl2(~ind) = 0;
        inc = xi(2:end) - xi(1:end - 1);        
        kl2 = sum(((kl2(2:end) + kl2(1:end - 1)) / 2) .* inc);

        kl(i, j) = kl1;
        kl(j, i) = kl2;        
    end
        
    disp(['Finished TSP: ', fileNames{i}]);
    save('densities.mat', 'kl', '-append');
end