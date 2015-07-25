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

e=(1 1.25 1.5 1.75 2 2.25 2.5 2.75 3 3.25 3.5 3.75 4 4.25 4.5 4.75 5 5.25 5.5 5.75 6 6.25 6.5 6.75 7 7.25 7.5 7.75 8 8.25 8.5 8.75 9 9.25 9.5 9.75 10)

PATH=~/path_to_your_files # Insert the path to where this is saved

dirBase=PATH/ATSP/
compressorLZMA=PATH/7z.exe
compressorFPC=PATH/fpc.exe
dirData=${dirBase}data/trial${trial}/
precision=10000000000

cd ${dirData}

for (( i = 0; i < ${#e[@]}; i++ ))
do
	# Problem 1
	p1=e${e[${i}]}
	
	# LZMA: Problem 1
	t1=$(($(date +%s%N)))
	${compressorLZMA} a -t7z ${p1}.7z ${p1}.bin -m0=LZMA -mx=9 > /dev/null
	t2=$(($(date +%s%N)))
	lzma1Time=$((${t2}-${t1}))
	
	# FPC: Problem 1
	t1=$(($(date +%s%N)))
	$(${compressorFPC} 26 ${p1}.bin ${p1}.fpc)
	t2=$(($(date +%s%N)))
	fpc1Time=$((${t2}-${t1}))
	
	for (( j = $i; j < $i+1; j++ ))
	do
		p2=e${e[${j}]}
		p12=e${e[${i}]}_e${e[${j}]}

		# LZMA: Problem 2
		t1=$(($(date +%s%N)))
		${compressorLZMA} a -t7z ${p2}.7z ${p2}.bin -m0=LZMA -mx=9 > /dev/null
		t2=$(($(date +%s%N)))
		lzma2Time=$((${t2}-${t1}))

		# LZMA: Problem 1 and 2
		t1=$(($(date +%s%N)))
		${compressorLZMA} a -t7z ${p12}.7z ${p12}.bin -m0=LZMA -mx=9 > /dev/null
		t2=$(($(date +%s%N)))
		lzma12Time=$((${t2}-${t1}))
	
		# FPC: Problem 2
		t1=$(($(date +%s%N)))
		$(${compressorFPC} 26 ${p2}.bin ${p2}.fpc)
		t2=$(($(date +%s%N)))
		fpc2Time=$((${t2}-${t1}))

		# FPC: Problem 1 and 2
		t1=$(($(date +%s%N)))
		$(${compressorFPC} 26 ${p12}.bin ${p12}.fpc)
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
		str="${p1} ${p2} 0.${ncd} ${lzmaTime}"
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
		str="${p1} ${p2} 0.${ncd} ${fpcTime}"
		echo "FPC: $str"
		# Write data in file
		echo $str >> results_fpc.dat
		
		# Remove compressed files
		rm ${p2}.7z ${p12}.7z ${p2}.fpc ${p12}.fpc
	done
	# Remove compressed files
	rm ${p1}.7z ${p1}.fpc
done
