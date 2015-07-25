% Script for calculating compressor properties for concatenated datasets
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
walks = 1:30;

problems = {'griewank', 'michalewicz', 'rastrigin', 'rosenbrock'};
compressors = {'lzma', 'ppmd', 'gzip', 'bzip2', 'fpc'};
origInd = 3;
lzmaInd = 4;
ppmdInd = 5;
gzipInd = 6;
bzip2Ind = 7;
fpcInd = 8;

idemCheck = zeros(length(problems), length(walks), length(compressors));
monoCheck = zeros(length(problems), length(walks), length(walks)-1, length(compressors));
symmCheck = zeros(length(problems), length(walks), length(walks)-1, length(compressors));
distCheck = zeros(length(problems), length(walks), length(walks)-1, length(walks)-2, length(compressors));

for i=1:length(problems)
    sizes = load([dirName,problems{i},'/sizes_concat.dat']);
    sizesSingle = load([dirName,problems{i},'/sizes_single.dat']);
    
    for j=1:length(walks)
        ind = sizesSingle(:,1) == walks(j);
        x = sizesSingle(ind,3:end);
        
        ind = (sizes(:,1) == sizes(:,2)) & (sizes(:,1) == walks(j));
        xx = sizes(ind,lzmaInd:fpcInd);
        
        % Check Z(xx) == Z(x)
        idemCheck(i,j,:) = xx ./ x;
        
        ctr = 1;
        for k=1:length(walks)
            if (j==k)
                continue;
            end
            ind = (sizes(:,1) == walks(j)) & (sizes(:,2) == walks(k));
            xy = sizes(ind,lzmaInd:fpcInd);
            
            % Check Z(xy) > Z(x)
            monoCheck(i,j,ctr,:) = xy ./ x;
            
            ind = (sizes(:,1) == walks(k)) & (sizes(:,2) == walks(j));
            yx = sizes(ind,lzmaInd:fpcInd);
            
            % Check Z(xy) == Z(yx)
            if (yx > xy)
                symmCheck(i,j,ctr,:) = yx ./ xy;
            else
                symmCheck(i,j,ctr,:) = xy ./ yx;
            end
            
            ctr2 = 1;
            for m=1:length(walks)
                if (m==j || m==k)
                    continue;
                end
                
                ind = sizesSingle(:,1) == walks(m);
                w = sizesSingle(ind,3:end);
                
                ind = sizes(:,1) == walks(i) & sizes(:,2) == walks(m);
                xw = sizes(ind,lzmaInd:fpcInd);
                
                ind = sizes(:,1) == walks(j) & sizes(:,2) == walks(m);
                yw = sizes(ind,lzmaInd:fpcInd);
                
                % Check Z(xy) + Z(w) <= Z(xw) + Z(yw)
                distCheck(i,j,ctr,ctr2,:) = (xw + yw) ./ (xy + w);
                ctr2 = ctr2 + 1;
            end
            
            ctr = ctr + 1;
        end
    end
end

idemOutput = reshape(mean(idemCheck,2),length(problems),length(compressors));

monoOutput = reshape(monoCheck,length(problems), length(walks)*(length(walks)-1), length(compressors));
monoOutput = reshape(sum(monoOutput < 1, 2), length(problems),length(compressors));

symmOutput = reshape(mean(mean(symmCheck,3),2),length(problems),length(compressors));

distOutput = reshape(distCheck, length(problems), length(walks)*(length(walks)-1)*(length(walks)-2), length(compressors));
distOutput = reshape(sum(distOutput < 1, 2), length(problems), length(compressors));