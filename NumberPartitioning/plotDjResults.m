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
k = 0.4:0.025:1.3;
totalProblems = length(k);
trials = 1:10;

distances = zeros(length(trials), totalProblems, totalProblems);
for t=1:length(trials)
    dataKL = load(['data/trial', num2str(trials(t)), '/densities.mat']);
    distances(t, :, :) = dataKL.kl' + dataKL.kl; % J Divergence
end
distances = reshape(mean(distances,1), totalProblems, totalProblems);
save('distances_kl.mat', 'distances');

% t-SNE
dimension = 2;
epsilon = 1e-5;

[perplexity, cost] = calculatePerplexity(distancesMean, 1000, 1:0.5:50, epsilon);
% perplexity = 5;
p = d2p((distances / range(distances(:))).^2, perplexity, epsilon);
[points cost] = tsne_p(p, [], dimension);

% Dendrogram
z = linkage(squareform(distances), 'average');
f1 = figure;
[handles, groups] = dendrogram(z, totalProblems);
close(f1);

mSize = 10;
fontSize = 18;
figure;
hold on;
set(gca, 'FontSize', 14);
labels = cell(1, totalProblems);
for i=1:totalProblems
	plot(points(i, 1), points(i, 2), 'o', 'MarkerSize', mSize,...
        'MarkerFaceColor', [1 - (i - 1), 1 - (i - 1), 1 - (i - 1)] ./ totalProblems,...
        'MarkerEdgeColor', 'k');
    text(points(i, 1), points(i, 2), ['  ', num2str(k(i))]);
    labels{i} = num2str(k(i));
end
dendrogram(z, totalProblems, 'labels', labels);
set(gca, 'XTickLabel', labels)
xlabel('k', 'FontSize', fontSize)
ylabel('D_J', 'FontSize', fontSize);
set(gca, 'FontSize', 14);

% Heatmap
plotHeatmap(distances, 'k', k);
set(gca, 'FontSize', 14);