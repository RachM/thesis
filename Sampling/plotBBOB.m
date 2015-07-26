% Script for plotting the dispersion and FDC of the BBOB functions. 
% The metrics are calculated using a uniform random walk
% with Lp norms p = 0.1, 0.5, 1 and 2, as well as a fixed step walk and
% Levy random walk.
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
load([dirName,'bbob_samples.mat']);

dim = [1:50, 100, 150, 200];
c = range(bounds) .* sqrt(dim)'; % Used to normalise dispersion
c = repmat(c,1,length(fn));

walks = {unif, levy, fixed};
labels = {'FDC', 'FDC Estimate', 'Dispersion'};
ax = {[0 dim(end) -0.5 1], [0 dim(end) -0.5 1], [0 dim(end) 0 0.45]};
fontSize = 18;
colors = {[0 0 1], [1 0 0], [0 0.7 0], [255 / 255, 177 / 255, 100 / 255], [0 0 0]};

for i=1:length(walks)
    datasets = {walks{i}.fdc, walks{i}.fdcEst, walks{i}.dispersion};
    f1 = figure;
    f2 = figure;
    f3 = figure;

    figures = {f1, f2, f3};

    for j=1:length(datasets)
        data = datasets{j};
        
%         data = reshape(data(1:length(dim),fnInd,:), length(dim), length(seeds));
        data = mean(data,3);
        
        if (j == 3)
            data = data ./ c;
        end
        figure(figures{j});
        xlabel('Dimension', 'FontSize', fontSize);
        ylabel(labels{j}, 'FontSize', fontSize);
        hold on;
        classes = [1, 6, 10, 15, 20];
        for k=1:length(classes)
            plot(dim(1), data(1,fn(classes(k))), 'Color', colors{k});
        end
        legend('F1 - F5', 'F6 - F9', 'F10 - F14', 'F15 - F19', 'F20 - F25');
        
        for fnId=1:length(fn)
            colorInd = 5;
            if fn(fnId)<6
                colorInd = 1;
            elseif fn(fnId) < 10
                colorInd = 2;
            elseif fn(fnId) < 15
                colorInd = 3;
            elseif fn(fnId) < 20
                colorInd = 4;
            end
            
            plot(dim(1:49), data(1:49, fn(fnId)), 'Color', colors{colorInd});
            plot(dim(49:52), data(49:52, fn(fnId)), 'x:', 'Color', colors{colorInd});
            text(dim(end), data(end, fn(fnId)), [' F' ,num2str(fn(fnId))], 'FontSize', 10)
        end

%         figure;
%         boxplot(data')
%         xlabel('Dimension');
%         ylabel(labels{j});
        axis(ax{j});
    end
end