% Script for calculating the length scales
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

dirName = 'data/';
% tspType = 'Symmetric';
% tspNames = {'kroA100','kroB100','kroC100','kroD100','kroE100','bayg29','bays29','gr17', 'gr21', 'gr24', 'gr48', 'ulysses16', 'ulysses22'};
% seed = 1100;
tspType = 'Asymmetric';
tspNames = {'br17','ft53','ft70','ftv33','ftv35','ftv38', 'ftv44', 'ftv47', 'ftv55', 'ftv64', 'p43', 'ry48p', 'kro124p'};
seed = 1000;

for i=1:length(tspNames)
    RandStream.setDefaultStream(RandStream('mt19937ar','seed', seed + i)); % So we get different rand
    saveName = [dirName, tspType, '_', tspNames{i}, '.mat'];
    
    [tspDist, tspSpec, tspCoord] = loadTsp(tspNames{i}, tspType);
    
    dim = tspSpec.nCities;
    nLengthScales = 2.5 * 10^(5) * dim;
    lengthScales = zeros(nLengthScales, 1);
    
    % Calculate length scales
    x1 = randperm(dim);
    ind1 = sub2ind(size(tspDist), x1, [x1(2:end), x1(1)]);
    for j=1:nLengthScales-1
        x2 = randperm(dim);
        while (sum(x1 ~= x2) == 0)
            x2 = randperm(dim); % Different
        end
        ind2 = sub2ind(size(tspDist), x2, [x2(2:end), x2(1)]);
        
        cost1 = sum(tspDist(ind1), 2);
        cost2 = sum(tspDist(ind2), 2);
        
        sharedEdges = length(intersect(ind1,ind2));
        if (strmatch('Symmetric', tspType))
            ind2 = sub2ind(size(tspDist), [x2(2:end), x2(1)], x2); % For symmetric problems
            sharedEdges = sharedEdges + length(intersect(ind1, ind2));
        end
        deltaX = 1 - sharedEdges / dim;
        
        % Calculate length scale between and add to set
        if (deltaX > 0) % This should always happen
            lengthScales(j) = abs(cost1 - cost2) / deltaX;
        end
        x1 = x2;
        ind1 = ind2;
    end
    
    lengthScales = sort(lengthScales);
    
    fid = fopen([dirName, tspType,'_', tspNames{i}, '.bin'], 'w+');
    fwrite(fid, lengthScales, 'double', 0, 'l');
    fclose(fid);
    
    disp(['Finished: ',tspNames{i}]);
end