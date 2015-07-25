% Script for plotting the J-divergence visualisations, heatmaps and dendrograms
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

% Settings
ell = 1:0.25:10;
totalProblems = length(ell);
dirName = 'data';

load('densities.mat');
distances = kl + kl';

% t-SNE
dimension = 2;
epsilon = 1e-5;
[perplexity, cost] = calculatePerplexity(distances, 1000, 1:0.5:50, epsilon);
% perplexity = 5;
p = d2p((distances / range(distances(:))).^2, perplexity, epsilon);
[points cost] = tsne_p(p, [], dimension);

% Dendrogram
z = linkage(squareform(distances), 'average');
f1 = figure;
[handles, groups] = dendrogram(z, totalProblems, 'Reorder', 1:totalProblems);
close(f1);
mSize = 10;
fontSize = 16;
figure;
hold on;
set(gca, 'FontSize', 14);
labels = cell(1, totalProblems);
for i=1:totalProblems
	plot(points(i, 1), points(i, 2), 'o', 'MarkerSize', mSize,...
        'MarkerFaceColor', [1 - (i - 1), 1 - (i - 1), 1 - (i - 1)] ./ totalProblems,...
        'MarkerEdgeColor', 'k');
    text(points(i, 1), points(i, 2), ['  ', num2str(ell(i))]);
    labels{i} = num2str(ell(i));
end

% Dendrogram
dendrogram(z, totalProblems, 'labels', labels, 'Reorder', 1:totalProblems);
set(gca, 'XTickLabel', labels)
xlabel('a', 'FontSize', fontSize)
ylabel('NCD', 'FontSize', fontSize);
set(gca, 'FontSize', 14);

% Heatmap
plotHeatmap(distances, 'a', ell);
set(gca, 'FontSize', 14);