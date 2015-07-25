% Script for comparing J-divergence to NCD
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

type = 'lzma';
dim = 1:15;

dataKL = load('densities.mat');
distKL = dataKL.kl; % KL Divergence
distJ = dataKL.kl' + dataKL.kl; % J Divergence
dataNCD = load(['distances_', type,'.mat']);
distNCD = dataNCD.distances;

dJ = zeros((length(dim)-1) * (length(dim)-2) / 2, 1);
dNCD = zeros((length(dim)-1) * (length(dim)-2) / 2, 1);
ctr = 1;

for ind1=1:length(dim)
    for ind2=(ind1+1):(length(dim)-1)        
        dJ(ctr) = distJ(ind1, ind2);
        dNCD(ctr) = distNCD(ind1, ind2);
        ctr = ctr + 1;
    end
end

[r1,p1] = corr(dNCD, dJ);
disp(['Pearson NCD vs J-div:', num2str(r1), ' at ', num2str(p1)]);

[r1,p1] = corr(dNCD, dJ, 'type', 'Spearman');
disp(['Spearman NCD vs J-div:', num2str(r1), ' at ', num2str(p1)]);

[r1,p1] = corr(dNCD, dJ, 'type', 'Kendall');
disp(['Kendall NCD vs J-div:', num2str(r1), ' at ', num2str(p1)]);

% Figure
figure;
fontSize = 14;
hold on;
plot(dNCD, dJ, 'kx');
xlabel('NCD', 'FontSize', fontSize);
ylabel('$D_J$', 'FontSize', fontSize,'Interpreter','LaTex');