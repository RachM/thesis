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
fns = 1:24;

colorInd = 4;
colors = {'b', 'r', [0 0.7 0], 'k'};
markers = {'o', 's', 'p', 'x'};

dim = 20;
dirName = 'data/';
dirNameSuffix = 'D/metrics/kl.mat';

dataKL = load([dirName, num2str(dim), dirNameSuffix]);
kl = reshape(mean(dataKL.kl(1, :, :, :), 2), length(fns), length(fns));
distKL = kl + kl'; % J Divergence
dataNCD = load(['distances_', type, '.mat']);
distNCD = dataNCD.distances20D;

dKL = zeros((length(fns) - 1) * (length(fns) - 2) / 2, 1);
dNCD = zeros((length(fns) - 1) * (length(fns) - 2) / 2, 1);
ctr = 1;

for ind1=1:length(fns)
    for ind2=(ind1 + 1):(length(fns) - 1)              
        dKL(ctr) = distKL(ind1, ind2);
        dNCD(ctr) = distNCD(ind1, ind2);
        ctr = ctr + 1;
    end
end

[r1,p1] = corr(dNCD, dKL);
disp(['Pearson NCD vs J-div:', num2str(r1), ' at ', num2str(p1)])

[r1,p1] = corr(dNCD, dKL, 'type', 'Spearman');
disp(['Spearman NCD vs J-div:', num2str(r1), ' at ', num2str(p1)])

[r1,p1] = corr(dNCD, dKL, 'type', 'Kendall');
disp(['Kendall NCD vs J-div:', num2str(r1), ' at ', num2str(p1)])

% Figure
figure;
fontSize = 14;
hold on;
semilogy(dNCD, dKL, markers{colorInd}, 'Color', colors{colorInd});
xlabel('NCD', 'FontSize', 18);
ylabel('$D_J$', 'FontSize', 18, 'Interpreter', 'LaTex');
set(gca, 'FontSize', fontSize);
set(gca, 'YScale', 'log')