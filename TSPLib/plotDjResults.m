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
fileNames = {...
    'Symmetric_kroA100','Symmetric_kroB100','Symmetric_kroC100','Symmetric_kroD100',...
    'Symmetric_kroE100','Symmetric_bayg29','Symmetric_bays29','Symmetric_gr17', 'Symmetric_gr21',...
    'Symmetric_gr24', 'Symmetric_gr48', 'Symmetric_ulysses16', 'Symmetric_ulysses22', ...
    ...
    'Asymmetric_br17','Asymmetric_ft53','Asymmetric_ft70','Asymmetric_ftv33','Asymmetric_ftv35',...
    'Asymmetric_ftv38', 'Asymmetric_ftv44', 'Asymmetric_ftv47', 'Asymmetric_ftv55', 'Asymmetric_ftv64', ...
    'Asymmetric_p43', 'Asymmetric_ry48p', 'Asymmetric_kro124p'};

totalProblems = length(fileNames);

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
z = linkage(squareform(distances),'average');
f1 = figure;
[handles, groups] = dendrogram(z,totalProblems,'Reorder',1:totalProblems);
close(f1);

mSize = 10;
fontSize = 16;
figure;
hold on;
set(gca, 'FontSize', 14);
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