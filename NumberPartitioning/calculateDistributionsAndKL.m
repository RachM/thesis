% Script for calculating the length scale distributions and KL divergence.
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

trials = 2:10;
n = 20;
k = 0.4:0.025:1.3;
nKernel = 1000;
xKernel = linspace(0,1,nKernel);

for t=1:length(trials)
    dirName = ['data/trial', num2str(trials(t)), '/'];

    pKernel = zeros(length(k), nKernel);
    xKernel = zeros(length(k), nKernel);
    bandwidths = zeros(length(k),1);
    kl = zeros(length(k));
    load([dirName, 'densities.mat']);

    for i=1:length(k)
        fid = fopen([dirName,'k',num2str(k(i)),'.bin']);
        ls1 = fread(fid, inf, 'double', 0, 'l')';
        fclose(fid);
        ls1 = ls1 / 2^(n*k(i));

        % Make kernel density estimate
        bandwidths(i) = fast_univariate_bandwidth_estimate_STEPI(length(ls1),ls1,10^(-3));
        [pKernel1 xKernel1] = ksdensity(ls1, 'width', bandwidths(i), 'npoints', nKernel);
        pKernel(i,:) = pKernel1;
        xKernel(i,:) = xKernel1;

        disp(['k: ', num2str(k(i))]);
        save([dirName, 'densities.mat'], 'pKernel', 'xKernel', 'bandwidths');
    end

    disp('Saved kernel density estimates');

    for i=1:length(k)
        fid = fopen([dirName,'k',num2str(k(i)),'.bin']);
        ls1 = fread(fid, inf, 'double', 0, 'l')';
        fclose(fid);
        ls1 = ls1 / 2^(n*k(i));

        for j=i+1:length(k)
            fid = fopen([dirName,'k',num2str(k(j)),'.bin']);
            ls2 = fread(fid, inf, 'double', 0, 'l')';
            fclose(fid);
            ls2 = ls2 / 2^(n*k(j));

%             xi = union(xKernel(i,:), xKernel(j,:));
%             p1 = ksdensity(ls1, xi, 'width', bandwidths(i), 'npoints', nKernel);
%             p2 = ksdensity(ls2, xi, 'width', bandwidths(j), 'npoints', nKernel);

            xi = xKernel;
            inc = xi(2:end) - xi(1:end-1);
            p1 = pKernel(i,:);
            p2 = pKernel(j,:);

            kl1 = p1 ./ p2;
            ind = kl1~=0 & ~isinf(kl1) & ~isnan(kl1);
            kl1 = p1 .* log2(kl1);
            kl1(~ind) = 0;
            kl1 = sum(((kl1(2:end) + kl1(1:end-1)) / 2) .* inc);
            
            kl2 = p2 ./ p1;
            ind = kl2~=0 & ~isinf(kl2) & ~isnan(kl2);
            kl2 = p1 .* log2(kl2);
            kl2(~ind) = 0;
            kl2 = sum(((kl2(2:end) + kl2(1:end-1)) / 2) .* inc);
            
            kl(i, j) = kl1;
            kl(j, i) = kl2;        
        end

        disp(['Finished k: ', num2str(k(i))]);
        save([dirName, 'densities.mat'], 'kl', '-append');
    end
end