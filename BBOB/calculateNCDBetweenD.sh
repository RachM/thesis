#!/bin/bash
# Calculates the NCD between the BBOB problems with different dimensions
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

precision=10000000000
fpcRate=28

d1=10
d2=20

dirBase=PATH/BBOB/data/
compressorLZMA=PATH/7z.exe
compressorFPC=PATH/fpc.exe
dirData=${dirBase}/${d1}D_vs_${d2}D/

f=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24)

for (( i = 0; i < ${#f[@]}; i++ ))
do
	p1=d${d1}_f${f[${i}]}
	
	# LZMA
	t1=$(($(date +%s%N)))
	${compressorLZMA} a -t7z -m0=LZMA -mx=9 ${dirData}${p1}.7z ${dirBase}/${d1}D/f${f[${i}]}.bin > /dev/null
	#$(${compressorLZMA} a -t7z -m0=LZMA -mx=9 ${p1}.7z ${p1}.bin)
	t2=$(($(date +%s%N)))
	lzma1Time=$((${t2}-${t1}))
	
	# FPC
	t1=$(($(date +%s%N)))
	$(${compressorFPC} ${fpcRate} ${dirBase}/${d1}D/f${f[${i}]}.bin ${dirData}${p1}.fpc)
	t2=$(($(date +%s%N)))
	fpc1Time=$((${t2}-${t1}))
	
	for (( j = 0; j < ${#f[@]}; j++ ))
	do		
		p2=d${d2}_f${f[${j}]}
		p12=${d1}D_f${f[${i}]}_${d2}D_f${f[${j}]}
		
		# LZMA
		t1=$(($(date +%s%N)))
		${compressorLZMA} a -t7z ${dirData}${p2}.7z ${dirBase}/${d2}D/f${f[${j}]}.bin -m0=LZMA -mx=9 > /dev/null
		t2=$(($(date +%s%N)))
		lzma2Time=$((${t2}-${t1}))

		# LZMA
		t1=$(($(date +%s%N)))
		${compressorLZMA} a -t7z ${dirData}${p12}.7z ${dirData}${p12}.bin -m0=LZMA -mx=9 > /dev/null
		t2=$(($(date +%s%N)))
		lzma12Time=$((${t2}-${t1}))
	
		# FPC
		t1=$(($(date +%s%N)))
		$(${compressorFPC} ${fpcRate} ${dirBase}/${d2}D/f${f[${j}]}.bin ${dirData}${p2}.fpc)
		t2=$(($(date +%s%N)))
		fpc2Time=$((${t2}-${t1}))

		# FPC
		t1=$(($(date +%s%N)))
		$(${compressorFPC} ${fpcRate} ${dirData}${p12}.bin ${dirData}${p12}.fpc)
		t2=$(($(date +%s%N)))
		fpc12Time=$((${t2}-${t1}))
		
		lzmaTime=$((${lzma1Time} + ${lzma2Time} + ${lzma12Time}))
		fpcTime=$((${fpc1Time} + ${fpc2Time} + ${fpc12Time}))
		
		# Perform NCD on LZMA
		minSize=$(stat -c%s "${dirData}${p1}.7z")
		maxSize=$(stat -c%s "${dirData}${p2}.7z")
		bothSize=$(stat -c%s "${dirData}${p12}.7z")
		if [ ${minSize} -gt ${maxSize} ]; then
			tempSize=${minSize}
			minSize=${maxSize}
			maxSize=${tempSize}
		fi
		ncd=$(((${bothSize} - ${minSize})*${precision} / ${maxSize}))
		str="${d1} ${f[${i}]} ${d2} ${f[${j}]} 0.${ncd} ${lzmaTime}"
		echo "LZMA: $str"
		#Write data in file
		echo $str >> ${dirData}results_lzma.dat
		
		# Perform NCD on FPC
		minSize=$(stat -c%s "${dirData}${p1}.fpc")
		maxSize=$(stat -c%s "${dirData}${p2}.fpc")
		bothSize=$(stat -c%s "${dirData}${p12}.fpc")
		if [ ${minSize} -gt ${maxSize} ]; then
			tempSize=${minSize}
			minSize=${maxSize}
			maxSize=${tempSize}
		fi
		ncd=$(((${bothSize} - ${minSize})*${precision} / ${maxSize}))
		str="${d1} ${f[${i}]} ${d2} ${f[${j}]} 0.${ncd} ${fpcTime}"
		echo "FPC: $str"
		# Write data in file
		echo $str >> ${dirData}results_fpc.dat
		
		
		# Remove compressed files
		rm ${dirData}${p2}.7z ${dirData}${p12}.7z ${dirData}${p2}.fpc ${dirData}${p12}.fpc
	done
	# Remove compressed files
	rm ${dirData}${p1}.7z ${dirData}${p1}.fpc
done