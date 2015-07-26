function kl = calculateDistributionsAndKLBetweenD(funcId, dim1, dim2)
% Calculates the length scale distributions and KL divergence between BBOB
% problems of different dimensions.
% 
% INPUTS:
%   - funcId: id of the BBOB function
%   - dim1: first dimension
%   - dim2: second fimension
%
% OUTPUT:
%   - kl: the KL divergences between the problem with dim1 and dim2.
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
    nSamples1 = 1000 * dim1^2;
    nSamples2 = 1000 * dim2^2;
    nKernel = 1000;
    walks = 1:30;
    seeds = 1:30;

    x1 = load(['data/', num2str(dim1), 'D/walks/x.mat']);
    x2 = load(['data/', num2str(dim2), 'D/walks/x.mat']);

    metrics1 = load(['data/', num2str(dim1), 'D/metrics/metrics.mat'], 'rKernelX', 'rBandwidth');
    metrics2 = load(['data/', num2str(dim2), 'D/metrics/metrics.mat'], 'rKernelX', 'rBandwidth');

    kl = zeros(length(seeds), length(walks));

    for k=1:length(seeds)
        f1 = load(['data/', num2str(dim1), 'D/walks/f_seed_', num2str(seeds(k)), '.mat']);
        f2 = load(['data/', num2str(dim2), 'D/walks/f_seed_', num2str(seeds(k)), '.mat']);

        for j=1:length(walks)
            x_temp1 = reshape(x1.x(walks(j), 1:nSamples1,:), nSamples1,dim1);
            x_temp2 = reshape(x2.x(walks(j), 1:nSamples2,:), nSamples2,dim2);

            f1_temp = reshape(f1.f(walks(j), funcId, 1:nSamples1), nSamples1, 1);
            f2_temp = reshape(f2.f(walks(j), funcId, 1:nSamples2), nSamples2, 1);

            xKernel1 = reshape(metrics1.rKernelX(seeds(k), walks(j), funcId, :), 1, nKernel);
            xKernel2 = reshape(metrics2.rKernelX(seeds(k), walks(j), funcId, :), 1, nKernel);
            xKernel = union(xKernel1, xKernel2);
            clear xKernel1 xKernel2;

            ind1 = randperm(length(f1_temp));
            ind2 = [ind1(2:end), ind1(1)];
            r1 = (abs(f1_temp(ind1) - f1_temp(ind2)) ./ sqrt(sum((x_temp1(ind1, :) - x_temp1(ind2, :)).^2, 2)))';
            clear x_temp1 f1_temp ind1 ind2;

            ind1 = randperm(length(f2_temp));
            ind2 = [ind1(2:end),ind1(1)];
            r2 = (abs(f2_temp(ind1) - f2_temp(ind2)) ./ sqrt(sum((x_temp2(ind1, :) - x_temp2(ind2, :)).^2, 2)))';
            clear x_temp2 f2_temp ind1 ind2;

            p1 = ksdensity(r1, xKernel, 'width', metrics1.rBandwidth(seeds(k), walks(j), funcId));
            p2 = ksdensity(r2, xKernel, 'width', metrics2.rBandwidth(seeds(k), walks(j), funcId));
            clear r1 r2;

            kl1 = p1 ./ p2;
            ind = kl1~=0 & ~isinf(kl1) & ~isnan(kl1);
            xKernelTemp = xKernel(ind);
            inc = xKernelTemp(2:end) - xKernelTemp(1:end-1);
            kl1 = p1(ind) .* log2(kl1(ind));
            kl1 = sum(((kl1(2:end) + kl1(1:end-1)) / 2) .* inc);

            kl2 = p2 ./ p1;
            ind = kl2~=0 & ~isinf(kl2) & ~isnan(kl2);
            xKernelTemp = xKernel(ind);
            inc = xKernelTemp(2:end) - xKernelTemp(1:end-1);
            kl2 = p2(ind) .* log2(kl2(ind));
            kl2 = sum(((kl2(2:end) + kl2(1:end-1)) / 2) .* inc);

            kl(seeds(k), walks(j)) = kl1;
            kl(seeds(k), walks(j)) = kl2;

            disp(['Finished walk: ', num2str(walks(j))]);
        end
        disp(['Seed: ', num2str(seeds(k))]);
    end
end