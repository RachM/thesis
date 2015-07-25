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

% Settings
precision = 10000000000;
k = [0.4 0.425 0.45 0.475 0.5 0.525 0.55 0.575 0.6 0.625 0.65 0.675 0.7 0.725 ...
    0.75 0.775 0.8 0.825 0.85 0.875 0.9 0.925 0.95 0.975 1 1.025 1.05 1.075...
    1.1 1.125 1.15 1.175 1.2 1.225 1.25 1.275 1.3];
totalProblems = length(k);
trials = 1:10;
type = 'lzma'; 
% type = 'fpc';

distances = zeros(length(trials), totalProblems, totalProblems);

for t=1:length(trials)
    dirName = ['data/trial', num2str(trials(t)), '/'];
    data = load([dirName, 'results_', type, '.dat']);
    data(:, 3) = data(:, 3) / precision;
    for i=1:length(k)
        for j=i:length(k)
            ind = (data(:, 1) == (k(i))) & (data(:, 2) == (k(j)));
            [temp ind] = max(ind);
            if (temp ~= 0)
                distances(trials(t), i, j) = data(ind, 3);
                distances(trials(t), j, i) = data(ind, 3);
            end
        end
    end
end

ind = distances > 1;
distances(ind) = 1;
distances = reshape(mean(distances,1), totalProblems, totalProblems);
save(['distances_', type, '.mat'], 'distances');

minD = min(distances(:));
ran = 1 - minD;
distances = (distances - minD) / ran;
ind = eye(totalProblems);
ind = logical(ind);
distances(ind) = 0;

% If you want to try MDS, uncomment the below
% opts = statset('MaxIter', 5000);
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
% perplexity = 4;
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
labels = cell(1,totalProblems);
for i=1:totalProblems
    col = [1 - (i - 1), 1 - (i - 1), 1 - (i - 1)] ./ totalProblems;
	plot(points(i,1), points(i,2), 'o', 'MarkerSize', mSize,...
        'MarkerFaceColor', col, 'MarkerEdgeColor', 'k');
    text(points(i, 1), points(i, 2), ['  ', num2str(k(i))]);
    labels{i} = num2str(k(i));
end
dendrogram(z, totalProblems, 'labels', labels, 'Reorder', 1:totalProblems);
labels = {};
for i=1:totalProblems
    labels{i} = '';
    if (mod(i, 2) == 1)
        labels{i} = num2str(k(i));
    end
end
set(gca, 'XTickLabel', labels)
xlabel('k', 'FontSize', fontSize)
ylabel('NCD', 'FontSize', fontSize);

% Heatmap
plotHeatmap(distances, 'k', k);