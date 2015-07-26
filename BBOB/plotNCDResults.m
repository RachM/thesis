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

dim = 10;
precision = 1e-8;
% type = 'fpc';
type = 'lzma';

data = load(['data/', num2str(dim), 'D/results_', type, '.dat']);
bbob = load('data/bbob.mat');

% only want dim and precision and the best
ind = (bbob.data(:,4) == precision) & (bbob.data(:,2) == dim) & (bbob.data(:,5) == 1);
ert = bbob.data(ind, [1, 3]);
ert(:, 2) = log10(ert(:, 2)); % log because problem 24 is enourmous!

fns = 24;
distances = zeros(fns);
timing = zeros(fns);
ctr = 1;

for i=1:fns-1
    for j=i+1:fns
        ind = (data(:, 1) == (i)) & (data(:, 2) == (j));
        [temp ind] = max(ind);
        if (temp == 0)
            return;
        end
        if (temp ~= 0)
            distances(i, j) = data(ind, 3);
            distances(j, i) = data(ind, 3);
            timing(i, j) = data(ind, 4) / (10^9);
            timing(j, i) = data(ind, 4) / (10^9);
        end
    end
end

% t-SNE
dimension = 2;
epsilon = 1e-5;
[perplexity, cost] = calculatePerplexity(distances, 1000, 1:0.5:50, epsilon);
% perplexity = 4;
p = d2p(distances.^2, perplexity, epsilon);
[points cost] = tsne_p(p, [], dimension);

mSize = 10;
figure;
hold on;

class1 = ert(:, 1) < 6;
class2 = ert(:, 1) > 5 & ert(:, 1) < 10;
class3 = ert(:, 1) > 9 & ert(:, 1) < 15;
class4 = ert(:, 1) > 14 & ert(:, 1) < 20;
class5 = ert(:, 1) > 19;

plot(points(find(class1), 1), points(find(class1), 2), 'bx', 'MarkerSize', mSize);
plot(points(find(class2), 1), points(find(class2), 2), 'go', 'MarkerSize', mSize);
plot(points(find(class3), 1), points(find(class3), 2), 'ms', 'MarkerSize', mSize);
plot(points(find(class4), 1), points(find(class4), 2), 'kp', 'MarkerSize', mSize);
plot(points(find(class5), 1), points(find(class5), 2), 'r.', 'MarkerSize', mSize);
legend('F1-5', 'F6-9', 'F10-14', 'F15-19', 'F20-24');

plot(points(class1, 1), points(class1, 2), 'bx', 'MarkerSize', mSize);
plot(points(class2, 1), points(class2, 2), 'go', 'MarkerSize', mSize);
plot(points(class3, 1), points(class3, 2), 'ms', 'MarkerSize', mSize);
plot(points(class4, 1), points(class4, 2), 'kp', 'MarkerSize', mSize);
plot(points(class5, 1), points(class5, 2), 'r.', 'MarkerSize', mSize);

for i=1:length(ert(:, 1))
    text(points(i, 1), points(i, 2), ['  f', num2str(ert(i, 1))], 'FontSize', 14);
end

% Dendrogram
z = linkage(squareform(distances), 'average');
figure;
[handles, groups] = dendrogram(z, totalProblems, 'labels', labels, 'Reorder', 1:totalProblems);
xlabel('Circles', 'FontSize', fontSize)
ylabel('NCD', 'FontSize', fontSize);

% Heatmap
plot_heatmap(distances, 'BBOB Function ID');
colormap('gray');
set(gca, 'XTick', [1, 5, 10, 15, 20, 24])
set(gca, 'XTickLabel', {'1', '5', '10', '15', '20', '24'})
set(gca, 'YTick', [1, 5, 10, 15, 20, 24])
set(gca, 'YTickLabel', {'1', '5', '10', '15', '20', '24'})
xlabel('BBOB Function ID');
ylabel('BBOB Function ID');
colorbar;