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

b=(0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8 5.9 6 6.1 6.2 6.3 6.4 6.5)

PATH=~/path_to_your_files # Insert the path to where this is saved

trial=10
dirBase=PATH/ATSP/
compressorLZMA=PATH/7z.exe
compressorFPC=PATH/fpc.exe
dirData=${dirBase}data/trial${trial}/

precision=10000000000
fpcRate=26

cd ${dirData}

for (( i = 0; i < ${#b[@]}; i++ ))
do
	p1=b${b[${i}]}
	
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
	
	for (( j = $i; j < ${#b[@]}; j++ ))
	do		
		p2=b${b[${j}]}
		p12=b${b[${i}]}_b${b[${j}]}
		
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
sed -i 's/b//g' *.dat