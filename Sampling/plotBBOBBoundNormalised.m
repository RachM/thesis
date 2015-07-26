% Script for plotting the bound normalised dispersion of the BBOB functions. 
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
fns = 1:24;

dirName = 'data/';
load([dirName,'bbob_samples.mat']);

% Normalise by bounds
c = range(bounds);
disp = unif.lp.dispersion(:, :, :, end);
disp = disp ./ c;
for i=1:length(fns)
    disp(:, i, :) = (disp(:, i, :) - dispMin) ./ (dispMax - dispMin);
end

m1 = reshape(mean(disp, 2), length(dim), length(fns));
v1 = reshape(std(disp, [], 2), length(dim), length(fns));

figure;
hold on;
colours1 = {'b', 'r', 'g', 'y', 'k'};
colours2 = {'b--', 'r--', 'g--', 'y--', 'k--'};
axis([0 200 0 0.55]);
ylabel('Dispersion')
xlabel('Dimension')

plot(dim(1:49), m1(1:49,1), 'b-');
plot(dim(1:49), m1(1:49,6), 'r-');
plot(dim(1:49), m1(1:49,10), '-', 'Color', [0 0.7 0]);
plot(dim(1:49), m1(1:49,15), '-', 'Color', [255/255, 177/255, 100/255]);
plot(dim(1:49), m1(1:49,20), 'k-');

legend('F1-5', 'F6-9', 'F10-14', 'F15-19', 'F20-24');

for i=1:length(fns)
    color = 'k';
    if i<6
        color = 'b';
    elseif i < 10
        color = 'r';
    elseif i < 15
        continue;
        color = 'g';
    elseif i< 20
        continue;
        color = 'y';
    end
    plot(dim(1:49) ,m1(1:49, i), [color, '-']);
    plot(dim(49:52), m1(49:52, i), [color, ':']);
%     errorbar(dim,m1(:,i),v1(:,i),color);
%     errorbar(dim,m2(:,i),v2(:,i),char(colours2{i}));
end


plot(dim(1:49), m1(1:49, 10:14), '-','Color', [0 0.7 0]);
plot(dim(49:52), m1(49:52, 10:14), 'x:','Color', [0 0.7 0]);
plot(dim(1:49), m1(1:49, 15:19), '-','Color', [255/255, 177/255, 100/255]);
plot(dim(49:52), m1(49:52, 15:19), 'x:','Color', [255/255, 177/255, 100/255]);