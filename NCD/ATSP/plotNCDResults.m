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
n = 10;
precision = 10000000000;
b = [0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8 5.9 6 6.1 6.2 6.3 6.4 6.5];

trials = 1:10;
dirName = 'data/';
totalProblems = length(b);
type = 'fpc';

distances = zeros(totalProblems,totalProblems,length(trials));
timing = zeros(totalProblems,totalProblems,length(trials));
for t=1:length(trials)
    data = load([dirName, 'trial', num2str(trials(t)), '/results_', type, '.dat']);
    data(:, 3) = data(:, 3) / precision;
    data(data(:, 3) < 0, 3) = 0; % Ensure minimum value is 0
    data(data(:, 3) > 1, 3) = 1; % Ensure maximum value is 1
    for i=1:length(b)
        for j=i:length(b)
            ind = (data(:, 1) == (b(i))) & (data(:, 2) == (b(j)));
            [temp ind] = max(ind);
            if (temp ~= 0)
                distances(i, j, trials(t)) = data(ind, 3);
                distances(j, i, trials(t)) = data(ind, 3);
                timing(i, j, trials(t)) = data(ind,4) / (10^9); % Convert to seconds
                timing(j, i, trials(t)) = data(ind,4) / (10^9);  % Convert to seconds
            end
        end
    end
end

distances = distances(:, :, trials);
timing = timing(:, :, trials);
save(['distances_', type, '.mat'], 'distances');
save(['timing_', type, '.mat'], 'timing');

% load(['distances_',type,'.mat']); % Run this later if you want
distancesMean = mean(distances, 3);
distancesStd = std(distances, [], 3);

minD = min(distancesMean(:));
ran = 1 - minD;
distancesMean = (distancesMean - minD) / ran;
ind = eye(totalProblems);
ind = logical(ind);
distancesMean(ind) = 0;

% If you want to try MDS, uncomment the below
% opts = statset('MaxIter', 5000);
% [points stress2 disparities] = mdscale(distancesMean,2,'Criterion','stress','Options',opts); % Non-metric MDS
% [points stress disparities] = mdscale(distancesMean,2,'Criterion','metricstress','Options',opts); % Metric MDS
% [points stress disparities] = mdscale(distancesMean,2,'Criterion','strain','Options',opts); % Metric MDS equivalent to classical
% [points eigen] = cmdscale(distancesMean); % Classical MDS

% t-SNE
dimension = 2;
epsilon = 1e-5;
[perplexity, cost] = calculatePerplexity(distancesMean, 1000, 1:0.5:50, epsilon);
p = d2p(distancesMean.^2, perplexity, epsilon);
[points cost] = tsne_p(p, [], dimension);

mSize = 10;
textSize = 12;
fontSize = 16;
figure;
hold on;

t1 = 1.25;
t2 = 3.25;
points1 = points(b < t1,:);
points2 = points(b >= t1 & b < t2,:);
points3 = points(b >= t2,:);

plot(points1(1,1), points1(1,2), 'b.','MarkerSize',mSize);
plot(points2(1,1), points2(1,2), 'ro','MarkerSize',mSize);
plot(points3(1,1), points3(1,2), 'ks','MarkerSize',mSize);

legend(['ED: ', num2str(min(b)), '-', num2str(t1)],...
    ['ED: ', num2str(t1), '-', num2str(t2)],...
    ['ED: ', num2str(t2), '-', num2str(max(b))]);

plot(points1(:,1), points1(:,2), 'b.', 'MarkerSize', mSize);
plot(points2(:,1), points2(:,2), 'ro', 'MarkerSize', mSize);
plot(points3(:,1), points3(:,2), 'ks', 'MarkerSize', mSize);

labels = cell(1,totalProblems);
for i=1:totalProblems
    col = [1 - (i - 1), 1 - (i - 1), 1 - (i - 1)] ./ totalProblems;
	plot(points(i,1), points(i,2), 'o', 'MarkerSize', mSize,...
        'MarkerFaceColor', col, 'MarkerEdgeColor', 'k');
	text(points(i,1), points(i,2), ['  ', num2str(b(i))]);
    labels{i} = num2str(b(i));
end

% Dendrogram
z = linkage(squareform(distancesMean),'average');
figure;
[handles, groups] = dendrogram(z,totalProblems,'labels',labels,'Reorder',1:totalProblems);
labels = {};
for i=1:totalProblems
    labels{i} = '';
    if (mod(i,5)==1)
        labels{i} = num2str(b(i));
    end
end
set(gca,'XTickLabel',labels)
xlabel('Effective Number of Digits', 'FontSize', fontSize);
ylabel('NCD', 'FontSize', fontSize);


% Heatmap
plotHeatmap(distancesMean, 'Effective Number of Digits', b);