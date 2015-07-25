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
addpath(genpath('COMMON'));
clear all;
clc;

type = 'lzma';
b = 0.5:0.1:6.5;
trial = 10;

dataKL = load('densities.mat');
distKL = dataKL.kl;
dataNCD = load(['distances_', type,'.mat']);
distNCD = dataNCD.distances;

dKL = zeros((length(b)-1) * (length(b)-2) / 2, 1);
dNCD = zeros((length(b)-1) * (length(b)-2) / 2, 1);
ctr = 1;

for ind1=1:length(b)
    for ind2=(ind1+1):(length(b)-1)        
        dKL(ctr) = mean(distKL(ind1, ind2, :), 3) + mean(distKL(ind2, ind1, :), 3);
        dNCD(ctr) = mean(distNCD(ind1, ind2, :), 3);
        ctr = ctr + 1;
    end
end

[r1,p1] = corr(dNCD, dKL)
disp(['Pearson NCD vs J-div:', num2str(r1), ' at ', num2str(p1)]);

[r1,p1] = corr(dNCD, dKL, 'type', 'Spearman')
disp(['Spearman NCD vs J-div:', num2str(r1), ' at ', num2str(p1)]);

[r1,p1] = corr(dNCD, dKL, 'type', 'Kendall')
disp(['Kendall NCD vs J-div:', num2str(r1), ' at ', num2str(p1)]);

% Figure
semilogy(dNCD, dKL, 'kx');
fontSize = 14;
hold on;
xlabel('NCD', 'FontSize', 18);
ylabel('$D_J$', 'FontSize', 17, 'Interpreter', 'LaTex');
set(gca, 'FontSize', fontSize);