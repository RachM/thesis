% Script for plotting the length scale distributions.
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

load('densities.mat');
fileNames = {...
    'Symmetric_kroA100','Symmetric_kroB100','Symmetric_kroC100','Symmetric_kroD100',...
    'Symmetric_kroE100','Symmetric_bayg29','Symmetric_bays29','Symmetric_gr17', 'Symmetric_gr21',...
    'Symmetric_gr24', 'Symmetric_gr48', 'Symmetric_ulysses16', 'Symmetric_ulysses22', ...
    ...
    'Asymmetric_br17','Asymmetric_ft53','Asymmetric_ft70','Asymmetric_ftv33','Asymmetric_ftv35',...
    'Asymmetric_ftv38', 'Asymmetric_ftv44', 'Asymmetric_ftv47', 'Asymmetric_ftv55', 'Asymmetric_ftv64', ...
    'Asymmetric_p43', 'Asymmetric_ry48p', 'Asymmetric_kro124p'...
    };
pInd = 1:length(fileNames);

lineType = {'-', '-', '-', '-','-', '-', ':', ':',':'};
colors = {...
    [0 0 0], [0 0 0], [0 0 0], [0 0 0],...
    [0 0 0], [1, 0, 0], [1, 0, 0], [0, 0.7, 0], [0, 0.7, 0],...
    [0, 0.7, 0], [0, 0.7, 0], [0.8, 0.33, 1], [0.8, 0.33, 1], ...
    ...
    [0 0 1], [1 0.66 0], [1 0.66 0], [1 0.66 0], [1 0.66 0],...
    [1 0.66 0], [1 0.66 0], [1 0.66 0], [1 0.66 0], [1 0.66 0], ...
    [0 0.66 1], [1 0 0.66], [0 0 0]...
    };
figure;
xlabel('r', 'FontSize', 18);
ylabel('p(r)', 'FontSize', 18);
set(gca, 'FontSize', 14);
hold on;
labels = {};

pFirst = [1,6,8,12,14,15,24,25];
labelFirst = {'kro','bay','gr','ulysses','br17','ft','p43','ry48p'};
for i=1:length(pFirst)
    plot(xKernel(pFirst(i),:), pKernel(pFirst(i),:), lineType{1}, 'Color', colors{pFirst(i)});
end
legend(labelFirst);

for i=1:length(pInd)
    plot(xKernel(pInd(i),:), pKernel(pInd(i),:), lineType{1}, 'Color', colors{i});
    
    label = fileNames{pInd(i)};
    ind = strfind(label, '_');
end