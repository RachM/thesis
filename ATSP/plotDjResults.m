% Script for plotting the J-divergence visualisations, heatmaps and
% dendrograms
% Assumptions:
%       - Data is in 'data/trialX' directory, where X is the trial number
%       - calculateKl has been run
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
b = [0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8 5.9 6 6.1 6.2 6.3 6.4 6.5];
totalProblems = length(b);
dirName = 'data/';
trials = 1:10;

kl = zeros(totalProblems,totalProblems,length(trials));
for t=1:length(trials)
    data = load([dirName, 'trial', num2str(trials(t)), '/densities.mat']);
    kl(:, :, trials(t)) = data.kl;    
end
save('densities.mat', 'kl');

% Calculate J-divergence
for t=1:length(trials)
    klT = kl(:,:,t) + kl(:,:,t)';
    kl(:,:,t) = klT;
end
distancesMean = mean(kl, 3);
distancesStd = std(kl, [], 3);
distancesMean = log10(distancesMean); % Take log since these are so large
ind = distancesMean < 0; % Shouldn't be any < 0
distancesMean(ind) = 0; 

% t-SNE
dimension = 2;
epsilon = 1e-5;
[perplexity, cost] = calculatePerplexity(distancesMean, 1000, 1:0.5:50, epsilon);
p = d2p((distancesMean / range(distancesMean(:))).^2, perplexity, epsilon);
[points cost] = tsne_p(p, [], dimension);

% t-SNE visualisation
mSize = 10;
fontSize = 16;
figure;
hold on;
set(gca, 'FontSize', 14);

t1 = 1.3;
t2 = 3.5;
points1 = points(b <= t1,:);
points2 = points(b > t1 & b <= t2,:);
points3 = points(b > t2,:);

plot(points1(1,1), points1(1,2), 'b.','MarkerSize',mSize);
plot(points2(1,1), points2(1,2), 'ro','MarkerSize',mSize);
plot(points3(1,1), points3(1,2), 'ks','MarkerSize',mSize);

legend([num2str(min(b)), '\leq b \leq ', num2str(t1)],...
    [num2str(t1), '< b \leq ', num2str(t2)],...
    [num2str(t2), '< b \leq ', num2str(max(b))]);

plot(points1(:,1), points1(:,2), 'b.', 'MarkerSize', mSize);
plot(points2(:,1), points2(:,2), 'ro', 'MarkerSize', mSize);
plot(points3(:,1), points3(:,2), 'ks', 'MarkerSize', mSize);

labels = cell(1, totalProblems);
for i=1:totalProblems
	text(points(i, 1), points(i, 2), ['  ', num2str(b(i))]);
    if (mod(i, 2) == 1)
        labels{i} = num2str(b(i));
    else
        labels{i} = '';
    end        
end

% Dendrogram
z = linkage(squareform(distancesMean), 'average');
f1 = figure;
[handles, groups] = dendrogram(z, totalProblems, 'Reorder', 1:totalProblems);
close(f1);
dendrogram(z, totalProblems, 'labels', labels, 'Reorder', 1:totalProblems);
set(gca,'XTickLabel', labels)
xlabel('b', 'FontSize', fontSize)
ylabel('log_{10}D_J', 'FontSize', fontSize);
set(gca, 'FontSize', 14);

% Heatmap
plotHeatmap(distancesMean, 'b', b);
set(gca, 'FontSize', 14);