function [ tspDist, tspSpec, tspCoord ] = loadTSP( tspName, tspType )
% Loads the TSPLib problem with the given name and type.
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

% Get Data
tspSpec = struct();
tspDist = [];
tspCoord = [];

fileExt = '.tsp';
if (strmatch('Asymmetric', tspType))
    fileExt = '.atsp';
end
fileName = [tspType, '/', tspName, fileExt];

% Open the data file and test for errors
[fid, errorMsg] = fopen(fileName, 'rt');
if (fid == -1)
  disp(['Error opening TSP: ', errorMsg]);
  return;
end

% Process data in the data file
dataRead = 1;
while dataRead,
    line = fgetl(fid); % get the current line
    
    if (any([~ischar(line), strmatch('EOF', line)]))
        dataRead = 0; % End of file
        break;
    end
    
    [txtOption, txtRemainder] = strtok(line, ':');
    if (strmatch('NAME', txtOption)) % Name
        tspSpec.name = strtok(txtRemainder(2:end));

    elseif (strmatch('COMMENT', txtOption)) % Comments
        tspSpec.comment = txtRemainder(2:end);

    elseif (strmatch('TYPE', txtOption)) % Type of TSP
        tspSpec.type = strtok(txtRemainder(2:end));

    elseif (strmatch('DIMENSION', txtOption)) % Number of cities
        tspSpec.nCities = sscanf(strtok(txtRemainder(2:end)), '%g');

    elseif (strmatch('EDGE_WEIGHT_TYPE', txtOption))
        tspSpec.edgeWeightType = strtok(txtRemainder(2:end));

    elseif (strmatch('NODE_COORD_TYPE', txtOption))
        tspSpec.coordType = strtok(txtRemainder(2:end));

    elseif (strmatch('EDGE_WEIGHT_FORMAT', txtOption))
        tspSpec.edgeWeightFormat = strtok(txtRemainder(2:end));

    elseif (strmatch('DISPLAY_DATA_TYPE', txtOption))
        tspSpec.displayDataType = strtok(txtRemainder(2:end));

    elseif (strmatch('NODE_COORD_SECTION', txtOption))
        nCoord = 2; % default
        if ((~isempty(strfind(tspSpec.edgeWeightType,'3D'))) || ...
                (isfield(tspSpec,'coordType') && strmatch(tspSpec.coordType,'THREED_COORDS')))
            nCoord = 3;
        end
        tspCoord = zeros(tspSpec.nCities, nCoord);
        for i=1:tspSpec.nCities
           line = fgetl(fid);
           data = sscanf(line, '%g');
           tspCoord(i, :) = data(2:end)';
        end

    elseif (strmatch('EDGE_WEIGHT_SECTION', txtOption))
        tspDist = zeros(tspSpec.nCities);
        if (strmatch('LOWER_DIAG_ROW', tspSpec.edgeWeightFormat))
            line = fgetl(fid);
            rowCtr = 1;
            colCtr = 1;
            while ischar(line)
                data = sscanf(line, '%g');
                for i = 1:length(data)
                    if (data(i)~=0)
                        tspDist(rowCtr,colCtr) = data(i);
                        tspDist(colCtr,rowCtr) = data(i);
                        colCtr = colCtr + 1;
                    else
                        rowCtr = rowCtr + 1;
                        colCtr = 1;
                    end
                end
                line = fgetl(fid);
            end
        elseif (strmatch('FULL_MATRIX', tspSpec.edgeWeightFormat))
            line = fgetl(fid);
            rowCtr = 1;
            colCtr = 1;
            while ischar(line)
                data = sscanf(line, '%g');
                for i = 1:length(data)
                    tspDist(rowCtr,colCtr) = data(i);
                    colCtr = colCtr + 1;
                    
                    if (colCtr > tspSpec.nCities)
                        rowCtr = rowCtr + 1;
                        colCtr = 1;
                    end
                end
                line = fgetl(fid);
            end
       elseif (strmatch('UPPER_ROW', tspSpec.edgeWeightFormat))
            for i = 1:tspSpec.nCities
               line = fgetl(fid);
               data = sscanf(line, '%g');
%                if (strmatch('FULL_MATRIX', tspSpec.edgeWeightFormat))
%                   tspDist(i, :) = data';
                  if (i > 1) 
                      addData = tspDist(1:i-1, i); 
                  else
                      addData = [];
                  end
                  tspDist(i, :) = [addData', 0, data'];
                  if (i == (tspSpec.nCities-1))
                     i = i + 1;
                     tspDist(i, :) = [tspDist(1:i-1, i)', 0];
                     break;
                  end
            end
        else
            warning(['Edge weight option not implemented: ', tspSpec.edgeWeightFormat]);
        end
    elseif (strmatch('DISPLAY_DATA_SECTION', txtOption))
        if (strmatch('TWOD_DISPLAY', tspSpec.displayDataType))
            tspDisplay = zeros(tspSpec.nCities,2);
            for i = 1:tspSpec.nCities
               line = fgetl(fid);
               data = sscanf(line, '%g');
               tspDisplay(i, :) = data(2:end)';
            end
        end

    elseif (any([isempty(txtOption), all(isspace(txtOption))]))
        % do nothing

    else
        warning(['Unrecognized option: ', txtOption]);
    end
end

% Assuming we have our data

if (isempty(tspDist))
    % We need to compute the distances - ASSUMES SYMMETRIC!
    switch(tspSpec.edgeWeightType)
        case 'EUC_2D'
            tspDist = squareform(round(pdist(tspCoord)));
        case 'EUC_3D'
            tspDist = squareform(round(pdist(tspCoord)));
        case 'MAN_2D'
            tspDist = squareform(round(pdist(tspCoord,'cityblock')));
        case 'MAN_3D'
            tspDist = squareform(round(pdist(tspCoord,'cityblock')));
        case 'MAX_2D'
            tspDist = distanceMaximum(tspCoord);
        case 'MAX_3D'
            tspDist = distanceMaximum(tspCoord);
        case 'GEO'
            tspDist = distanceGeo(tspCoord);
        case 'ATT'
            tspDist = distancePseudoEuclidean(tspCoord);
        case 'CEIL_2D'
            tspDist = squareform(ceil(pdist(tspCoord)));
        case 'XRAY1'
        case 'XRAY2'
        case 'SPECIAL'
    end
end

end