% Script for plotting the length scale distributions.
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

k = 0.4:0.025:1.3;
% k1 = 0.4:0.025:0.85;
% k2 = 0.875:0.025:1.0;
% k3 = 1.025:0.025:1.3;
totalProblems = length(k);
trials = 1:10;
nKernel = 1000;

pis = zeros(length(trials), totalProblems, nKernel);
xis = zeros(length(trials), totalProblems, nKernel);
ls = zeros(totalProblems, length(trials), 2^19);

figure;
hold on;
% plot(0,0,'b');
% plot(0,0,'Color', [0 0.7 0]);
% plot(0,0,'r');
% legend('0.4 \leq k \leq 0.8', '0.8 < k \leq 1', '1 < k \leq 1.3', 'Location', 'NorthWest');
% xlabel('Length Scale Index', 'FontSize', 18);
% ylabel('Normalised Length Scale Value', 'FontSize', 18);

for t=1:length(trials)
    dirName = ['data/trial', num2str(trials(t)), '/'];
    data = load([dirName, 'densities_normalised.mat']);
    pis(t, :, :) = data.pKernel;
%     xis(t,:,:) = data.xKernel;
    
%     for i=1:length(k3)
%         fid = fopen([dirName,'k',num2str(k3(i)),'.bin']);
%         ls1 = fread(fid, inf, 'double', 0, 'l')';
%         fclose(fid);
%         ls1 = ls1 / 2^(20*k3(i));
%         
%         plot(ls1, '.', 'Color', [1 0 0], 'LineWidth', 0.25);
%     end
%     
%     for i=1:length(k1)
%         fid = fopen([dirName,'k',num2str(k1(i)),'.bin']);
%         ls1 = fread(fid, inf, 'double', 0, 'l')';
%         fclose(fid);
%         ls1 = ls1 / 2^(20*k1(i));
%         
%         plot(ls1, '.', 'Color', [0 0 1], 'LineWidth', 0.25);
%     end
%     
%     for i=1:length(k2)
%         fid = fopen([dirName,'k',num2str(k2(i)),'.bin']);
%         ls1 = fread(fid, inf, 'double', 0, 'l')';
%         fclose(fid);
%         ls1 = ls1 / 2^(20*k2(i));
%         
%         plot(ls1, '.', 'Color', [0 0.7 0], 'LineWidth', 0.25);
%     end
end

pos = [37, 1, 22];
colors = {[1 0 0], [0 0 1], [0 0.7 0] };
plot(0, 0, 'Color', colors{2})
plot(0, 0, 'Color', colors{3})
plot(0, 0, 'Color', colors{1})
legend('k = 0.4', 'k = 0.925', 'k = 1.3');
fontSize = 18;
xlabel('r', 'FontSize', fontSize);
ylabel('p(r)', 'FontSize', fontSize);

pis(:,:,1) = 0;

for i=1:length(pos)
    plot(data.xKernel, reshape(pis(:, pos(i), :), length(trials), nKernel), 'Color', colors{i}, 'LineWidth', 1);
end
axis([-0.01 1 0 12])