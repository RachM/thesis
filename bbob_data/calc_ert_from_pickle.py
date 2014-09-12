# Script to extract ERTs from BBOB results
#
# Copyright (C) 2014 Rachael Morgan (rachael.morgan8@gmail.com)
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import sys, os
import scipy, numpy
import string, csv
import pickle

precisions = [1e3, 10, 0.1, 1e-3, 1e-5, 1e-8]
functionIds = numpy.r_[1:25]
dimensions = [2,5,10,20]

dirBbobMain = "./BBOB_data"
year = '';
dataFileName = 'ert.csv'

with open(dataFileName, 'wb') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['Algorithm Name', 'Function ID', 'Dimension', 'Year', 'Precision', 'ERT'])
    
for root, dirs, files in os.walk(dirBbobMain):
    if (len(dirs) > 0):
        year = root[len(dirBbobMain)+1:]
    else:
        # This is an algorithm's directory, full of pickles!
        print root[len(dirBbobMain)+6:]
        for file in files:
            # Load the pickle
            fh = open(root+'\\'+file,"rb")
            data = pickle.load(fh)
            fh.close()

            # Check if the function and dimension is what we want
            if (data.funcId in functionIds) and (data.dim in dimensions):
                # Get the ERTs for the precisions
                ertList = data.detERT(precisions)
                for i, ert in enumerate(ertList):
                    # Write the ERT/precision combo to the CSV
                    with open(dataFileName, 'a+b') as csvfile:
                        writer = csv.writer(csvfile)
                        writer.writerow([data.algId, data.funcId, data.dim, year, precisions[i], ert])