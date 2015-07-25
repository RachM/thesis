% Script for plotting the NCD visualisations, heatmaps and dendrograms
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

% Settings
a = 0:0.25:10;
dim = 1;
totalProblems = length(a);
dirName = ['data_', num2str(dim), 'D/'];
% type = 'fpc';
type = 'lzma';

data = load([dirName, 'results_', type, '.dat']);
distances = zeros(totalProblems);
timing = zeros(totalProblems);

for i=1:length(a)
    for j=i:length(a)
        ind = (data(:,1) == (a(i))) & (data(:,2) == (a(j)));
        [temp ind] = max(ind);
        if (temp ~= 0)
            timing(i, j) = data(ind, 4) / (10^9);
            timing(j, i) = data(ind, 4) / (10^9);
            distances(i, j) = data(ind, 3);
            distances(j, i) = data(ind, 3);
        end
    end
end
save(['distances_', type, '.mat'], 'distances');
save(['timing_', type, '.mat'], 'timing');

minD = min(distances(:));
ran = 1 - minD;
distances = (distances - minD) / ran;
ind = eye(totalProblems);
ind = logical(ind);
distances(ind) = 0;

% If you want to try MDS, uncomment the below
% opts = statset('MaxIter',10000);
% [points stress2 disparities] =
% mdscale(distances,2,'Criterion','stress','Options',opts); % Non-metric MDS
% [points stress disparities] = mdscale(distances,2,'Criterion','metricstress','Options',opts); % Metric MDS
% [points stress disparities] = mdscale(distances,2,'Criterion','strain','Options',opts); % Metric MDS equivalent to classical
% [points eigen] = cmdscale(distances); % Classical MDS
% pd = pdist(points);
% dissimilarities = squareform(distances);
% disparities = squareform(disparities);
% [dum,ord] = sortrows([disparities(:) dissimilarities(:)]);
% plot(dissimilarities,pd,'bo', ...
%      dissimilarities(ord),disparities(ord),'r.-')
% xlabel('NCD')
% ylabel('Plot Distances / Disparities')
% legend({'Plot Distances' 'Disparities'},...
%        'Location','NorthWest');

% t-SNE
dimension = 2;
epsilon = 1e-5;
[perplexity, cost] = calculatePerplexity(distances, 1000, 1:0.5:50, epsilon);
% perplexity = 32;
p = d2p(distances.^2, perplexity, epsilon);
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
labels = cell(1, totalProblems);
for i=1:totalProblems
	plot(points(i, 1), points(i, 2), 'o', 'MarkerSize', mSize,...
        'MarkerFaceColor', [1 - (i - 1), 1 - (i - 1), 1 - (i - 1)] ./ totalProblems,...
        'MarkerEdgeColor', 'k');
    text(points(i, 1), points(i, 2), ['  ', num2str(a(i))]);
    labels{i} = num2str(a(i));
end

% Dendrogram
dendrogram(z, totalProblems, 'labels', labels, 'Reorder', 1:totalProblems);
set(gca, 'XTickLabel', labels)
xlabel('A', 'FontSize', fontSize)
ylabel('NCD', 'FontSize', fontSize);

% Heatmap
plotHeatmap(distances, 'A', a);