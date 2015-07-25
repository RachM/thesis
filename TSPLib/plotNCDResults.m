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

dirName = 'data/';
precision = 10000000000;
fileNames = {...
    'Symmetric_kroA100','Symmetric_kroB100','Symmetric_kroC100','Symmetric_kroD100',...
    'Symmetric_kroE100','Symmetric_bayg29','Symmetric_bays29','Symmetric_gr17', 'Symmetric_gr21',...
    'Symmetric_gr24', 'Symmetric_gr48', 'Symmetric_ulysses16', 'Symmetric_ulysses22', ...
    ...
    'Asymmetric_br17','Asymmetric_ft53','Asymmetric_ft70','Asymmetric_ftv33','Asymmetric_ftv35',...
    'Asymmetric_ftv38', 'Asymmetric_ftv44', 'Asymmetric_ftv47', 'Asymmetric_ftv55', 'Asymmetric_ftv64', ...
    'Asymmetric_p43', 'Asymmetric_ry48p', 'Asymmetric_kro124p'};

totalProblems = length(fileNames);
% type = 'lzma';
type = 'fpc';

results = load([dirName,'results_',type,'.mat']);
data = results.data;
distances = zeros(totalProblems);
timing = zeros(totalProblems);

data(:,1) = data(:,1) / precision;
data(:,2) = data(:,2) / (10^9);
data(data(:,1) < 0, 1) = 0;
data(data(:,1) > 1, 1) = 1;
for i=1:length(fileNames)
    for j=i:length(fileNames)
        ind = (ismember(results.textdata(:,1),fileNames{i}) & (ismember(results.textdata(:,2),fileNames{j})));
        [temp ind] = max(ind);
        if (temp ~= 0)
            distances(i,j) = data(ind,1);
            distances(j,i) = data(ind,1);
            timing(i,j) = data(ind,2);
            timing(j,i) = data(ind,2);
        end
    end
end
save(['distances_',type,'.mat'], 'distances');
save(['timing_',type,'.mat'], 'timing');

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
[perplexity, cost] = calculatePerplexity(distancesMean, 1000, 1:0.5:50, epsilon);
% perplexity = 10;
p = d2p(distances.^2, perplexity, epsilon);
[points cost] = tsne_p(p, [], dimension);

mSize = 10;
textSize = 12;
fontSize = 16;
figure;
hold on;
labels = cell(1,totalProblems);
plot(points(1,1), points(1,2), 'ok','MarkerSize',mSize,...
        'MarkerFaceColor','k',...
        'MarkerEdgeColor','k');
plot(points(totalProblems,1), points(totalProblems,2), 'sw','MarkerSize',mSize,...
        'MarkerFaceColor','w',...
        'MarkerEdgeColor','k');
legend('Symmetric','Asymmetric');

for i=1:totalProblems
    label = fileNames{i};
    ind = strfind(label, '_');    
    labels{i} = label(ind+1:length(label));
    
    text(points(i,1), points(i,2), ['  ',labels{i}],'FontSize',12);
    
    shape = 'o';
    color = 'k';
    if (strcmp(label(1:ind-1),'Asymmetric'))
        shape = 's';
        color = 'w';
    end
	plot(points(i,1), points(i,2), shape,'MarkerSize',mSize,...
        'MarkerFaceColor',color,...
        'MarkerEdgeColor','k');
end

% Dendrogram
z = linkage(squareform(distances),'average');
figure;
[handles, groups] = dendrogram(z,'labels',labels,'orientation','right');
xlabel('TSP Instance', 'FontSize', fontSize);
ylabel('NCD', 'FontSize', fontSize);

% Heatmap
plotHeatmap(distances, 'TSP Instance');
set(gca,'XTick',1:totalProblems)
set(gca,'XTickLabel',cell(1,totalProblems))
set(gca,'YTick',1:totalProblems)
set(gca,'YTickLabel',labels)