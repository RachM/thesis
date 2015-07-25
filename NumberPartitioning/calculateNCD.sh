#!/bin/bash
# Calculates the NCD between the problems
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

k=(0.4 0.425 0.45 0.475 0.5 0.525 0.55 0.575 0.6 0.625 0.65 0.675 0.7 0.725 0.75 0.775 0.8 0.825 0.85 0.875 0.9 0.925 0.95 0.975 1 1.025 1.05 1.075 1.1 1.125 1.15 1.175 1.2 1.225 1.25 1.275 1.3)
PATH=~/path_to_your_files # Insert the path to where this is saved

dirBase=PATH/NumberPartitioning/
compressorLZMA=PATH/7z.exe
compressorFPC=PATH/fpc.exe
dirData=${dirBase}data/

precision=10000000000
fpcRate=26

trial=(1 2 3 4 5 6 7 8 9 10)

for (( t = 0; t < ${#trial[@]}; t++ ))
do
	dirData=${dirBase}data/trial${trial[${t}]}/
	cd ${dirData}

	for (( i = 0; i < ${#k[@]}; i++ ))
	do
		p1=k${k[${i}]}
		
		# LZMA
		t1=$(($(date +%s%N)))
		${compressorLZMA} a -t7z ${p1}.7z ${p1}.bin -m0=LZMA -mx=9 > /dev/null
		t2=$(($(date +%s%N)))
		lzma1Time=$((${t2}-${t1}))
		
		# FPC
		t1=$(($(date +%s%N)))
		$(${compressorFPC} ${fpcRate} ${p1}.bin ${p1}.fpc)
		t2=$(($(date +%s%N)))
		fpc1Time=$((${t2}-${t1}))
		
		for (( j = $i; j < ${#k[@]}; j++ ))
		do		
			p2=k${k[${j}]}
			p12=k${k[${i}]}_k${k[${j}]}
			
			# LZMA
			t1=$(($(date +%s%N)))
			${compressorLZMA} a -t7z ${p2}.7z ${p2}.bin -m0=LZMA -mx=9 > /dev/null
			t2=$(($(date +%s%N)))
			lzma2Time=$((${t2}-${t1}))

			# LZMA
			t1=$(($(date +%s%N)))
			${compressorLZMA} a -t7z ${p12}.7z ${p12}.bin -m0=LZMA -mx=9 > /dev/null
			t2=$(($(date +%s%N)))
			lzma12Time=$((${t2}-${t1}))
		
			# FPC
			t1=$(($(date +%s%N)))
			$(${compressorFPC} ${fpcRate} ${p2}.bin ${p2}.fpc)
			t2=$(($(date +%s%N)))
			fpc2Time=$((${t2}-${t1}))

			# FPC
			t1=$(($(date +%s%N)))
			$(${compressorFPC} ${fpcRate} ${p12}.bin ${p12}.fpc)
			t2=$(($(date +%s%N)))
			fpc12Time=$((${t2}-${t1}))
			
			lzmaTime=$((${lzma1Time} + ${lzma2Time} + ${lzma12Time}))
			fpcTime=$((${fpc1Time} + ${fpc2Time} + ${fpc12Time}))
			
			# Perform NCD on LZMA
			minSize=$(stat -c%s "${p1}.7z")
			maxSize=$(stat -c%s "${p2}.7z")
			bothSize=$(stat -c%s "${p12}.7z")
			if [ ${minSize} -gt ${maxSize} ]; then
				tempSize=${minSize}
				minSize=${maxSize}
				maxSize=${tempSize}
			fi
			ncd=$(((${bothSize} - ${minSize})*${precision} / ${maxSize}))
			str="${p1} ${p2} ${ncd} ${lzmaTime}"
			echo "LZMA: $str"
			# Write data in file
			echo $str >> results_lzma.dat
			
			# Perform NCD on FPC
			minSize=$(stat -c%s "${p1}.fpc")
			maxSize=$(stat -c%s "${p2}.fpc")
			bothSize=$(stat -c%s "${p12}.fpc")
			if [ ${minSize} -gt ${maxSize} ]; then
				tempSize=${minSize}
				minSize=${maxSize}
				maxSize=${tempSize}
			fi
			ncd=$(((${bothSize} - ${minSize})*${precision} / ${maxSize}))
			str="${p1} ${p2} ${ncd} ${fpcTime}"
			echo "FPC: $str"
			# Write data in file
			echo $str >> results_fpc.dat
					
			# Remove compressed files
			if [ $i -ne $j ]; then
				rm ${p2}.7z ${p2}.fpc
			fi
			rm ${p12}.7z ${p12}.fpc
		done
		# Remove compressed files
		rm ${p1}.7z ${p1}.fpc
	done

	# Clean data file
	sed -i 's/bin//g' *.dat
	sed -i 's/k//g' *.dat
done