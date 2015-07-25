#!/bin/bash
# Shell script for compressing the empty datasets.
# Assumptions:
#           - 2 compressors are used: 7zip and FPC
# Returns:
#           Saves the NCD values in results_<type>.dat files, where
# 			<type> is either fpc or lzma.
# 
# Copyright (C) 2015 Rachael Morgan (rachael.morgan8@gmail.com)
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

dirBase=PATH/CompressorInvestigation/
compressorLZMA=PATH/7z.exe
compressorFPC=PATH/fpc.exe
dirData=${dirBase}/data/

cd ${dirData}

# Problem
p1=empty
originalSize=$(stat -c%s "${p1}.bin")

# LZMA
t1=$(($(date +%s%N)))
${defaultCompressor} a -t7z ${p1}_lzma.7z ${p1}.bin -m0=LZMA -mx=9 > /dev/null
t2=$(($(date +%s%N)))
lzmaTime=$((${t2}-${t1}))
lzmaSize=$(stat -c%s "${p1}_lzma.7z")

# PPMD
t1=$(($(date +%s%N)))
${defaultCompressor} a -t7z ${p1}_ppmd.7z ${p1}.bin -m0=PPMd -mx=9 > /dev/null
t2=$(($(date +%s%N)))
ppmdTime=$((${t2}-${t1}))
ppmdSize=$(stat -c%s "${p1}_ppmd.7z")

# GZIP
t1=$(($(date +%s%N)))
${defaultCompressor} a -tgzip ${p1}.gzip ${p1}.bin -mx=9 > /dev/null
t2=$(($(date +%s%N)))
gzipTime=$((${t2}-${t1}))
gzipSize=$(stat -c%s "${p1}.gzip")

# BZIP2
t1=$(($(date +%s%N)))
${defaultCompressor} a -tbzip2 ${p1}.bzip2 ${p1}.bin -mx=9 > /dev/null
t2=$(($(date +%s%N)))
bzip2Time=$((${t2}-${t1}))
bzip2Size=$(stat -c%s "${p1}.bzip2")

# FPC
t1=$(($(date +%s%N)))
$(${compressorFPC} 26 ${p1}.bin ${p1}.fpc)
t2=$(($(date +%s%N)))
fpcTime=$((${t2}-${t1}))
fpcSize=$(stat -c%s "${p1}.fpc")

# Write data
strSizes="${p1} ${originalSize} ${lzmaSize} ${ppmdSize} ${gzipSize} ${bzip2Size} ${fpcSize}"
strTimes="${p1} ${lzmaTime} ${ppmdTime} ${gzipTime} ${bzip2Time} ${fpcTime}"
echo "$strSizes"
# Write data in file
echo $strSizes >> sizes_empty.dat
echo $strTimes >> time_empty.dat

# Remove compressed files
rm ${p1}_lzma.7z ${p1}_ppmd.7z ${p1}.gzip ${p1}.bzip2 ${p1}.fpc
