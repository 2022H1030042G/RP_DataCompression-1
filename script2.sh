#!/bin/bash
echo "Enter directory name"
read direct
echo "Enter compression tool"
read tool

if [ $tool = "zip" ]
 then
 	echo "Enter compression level"
 	read numz
	echo "Zipping now"
	python3 script.py "zip -$numz -r z.zip $direct" "compression using zip, level $numz"
	echo "Unzipping now"
	python3 script.py "unzip z.zip" "decompression using zip"
	echo -e "\n"
elif [ $tool = "gzip" ]
 then
 	echo "Enter compression level"
 	read num
	echo "Compressing using gzip now"
	python3 script.py "tar cvf - $direct | gzip -$num - > archive.tar.gz" "compression using gzip, level $num"
	echo "Decompressing using gzip now"
	python3 script.py "tar -zxvf archive.tar.gz" "decompression using gzip"
	echo -e "\n"
elif [ $tool = "zstd" ]
 then
 
 	#python3 script.py "zstd --train -r "/trainingset" -o dict" "building dictionary"
 	
	# echo "Enter level of compression"
	# read level
	for file_name in "$direct"/*
	do
		for((level = 1; level <= 21; level++))
		do
		echo "level - $level Compressing using zstd now"
		python3 script.py "tar -I 'zstd -$level' -cf archive.tar.zst $file_name" "compression using zstd, level $level"
		echo "Decompressing using zstd now"
		python3 script.py "tar -I 'zstd --decompress' -xf archive.tar.zst $file_name" "decompression using zstd"
		echo -e "\n"
		done
	done
	speaker-test -t sine -f 1000 -l 1 & sleep .2 && kill -9 $!
else
	echo "Invalid tool" 
fi


