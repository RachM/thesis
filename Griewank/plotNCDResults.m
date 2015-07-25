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
clc;
clear all;

% Settings
dim = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0.01,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.10,0.11,0.12,0.13,0.14,0.15];
dim1 = 1:15;
dim2 = [0.01,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.10,0.11,0.12,0.13,0.14,0.15];
totalProblems = length(dim);
dirName = 'data/';
% type = 'fpc';
type = 'lzma';

data = load([dirName, 'results_', type, '.dat']);
distances = zeros(totalProblems);
timing = zeros(totalProblems);

for i=1:length(dim)
    for j=i:length(dim)
        ind = (data(:, 1) == (dim(i))) & (data(:, 2) == (dim(j)));
        distances(i, j) = data(ind, 3);
        distances(j, i) = data(ind, 3);
        timing(i, j) = data(ind, 4) / (10^9);
        timing(j, i) = data(ind, 4) / (10^9);
    end
end

minD = min(distances(:));
ran = 1 - minD;
distances = (distances - minD) / ran;
distances(logical(eye(totalProblems))) = 0;


save(['distances_', type, '.mat'], 'distances');
save(['timing_', type, '.mat'], 'timing');

% If you want to try MDS, uncomment the below
% opts = statset('MaxIter',10000);
% [points stress2 disparities] = mdscale(distances,2,'Criterion','sstress','Options',opts); % Non-metric MDS
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
% perplexity = 6;
p = d2p(distances.^2, perplexity, epsilon);
[points cost] = tsne_p(p, [], dimension);

mSize = 10;
figure;
hold on; 
labels = cell(1, totalProblems);
labels2 = cell(1, totalProblems);
plot(points(1, 1), points(1, 2), 's', 'MarkerSize', mSize,...
        'MarkerFaceColor', [1,1,1], ...
        'MarkerEdgeColor', 'k');
plot(points(length(dim1)+1, 1), points(length(dim1)+1, 2), 'o', 'MarkerSize', mSize,...
        'MarkerFaceColor', [1,1,1], ...
        'MarkerEdgeColor', 'k');
legend('Griewank', 'Convex Component');
% 
for i=1:totalProblems
    marker = 's';
    labels{i} = num2str(dim(i));
    labels2{i} = ['G', num2str(dim(i))];
    mColor = (i - 1) / length(dim1);
    if (dim(i) < 1)
        marker = 'o';
        labels{i} = num2str(dim(i-length(dim1)));
        labels2{i} = ['C', labels{i}];
        mColor = (i-1-length(dim1)) / length(dim1);
    end
	plot(points(i, 1), points(i, 2), marker, 'MarkerSize', mSize ,...
        'MarkerFaceColor', [1 - mColor, 1 - mColor, 1 - mColor], ...
        'MarkerEdgeColor', 'k');
    text(points(i, 1), points(i, 2), ['  ',labels{i}]);
end

% Dendrogram
z = linkage(squareform(distances), 'average');
figure;
[handles, groups] = dendrogram(z, 'Orientation', 'top', 'labels', labels2);
xlabel('Function and Dimension')
ylabel('NCD');

% Heatmap
plotHeatmap(distances, 'Dimension');
set(gca, 'XTick', [1,15,30]);
set(gca, 'YTick', [1,15,30]);
set(gca, 'XTickLabel', {'G1', 'G15', 'C15'});
set(gca, 'YTickLabel', {'G1', 'G15', 'C15'});