#!/bin/bash

fw=$1
rw=$2
out=$3
nthreads=$4
indexAppendix=$5	# 9606/standardchr
unpaired=$6

#check if $out.bam exists, if not then do the following, else
[ -f "$out".bam ] && echo "[INFO] [HISAT] $out.bam already exists; skipping.."$'\n' && exit 

HISAT='/home/software/hisat2-2.1.0/hisat2'
HISATIndex="/home/data/indices/hisat2/$indexAppendix/INDEX"
samtools='/usr/local/bin/samtools'
java='/home/software/jdk-13.0.1/bin/java'
jar='/home/software/bamCleaner.jar'

[ ! -z "$unpaired" ] && echo "[INFO] [HISAT2] ["`date "+%Y/%m/%d-%H:%M:%S"`"] $HISAT -q --dta -p $nthreads -x $HISATIndex -U $fw -S $out.sam" && $HISAT -q --dta -p $nthreads -x $HISATIndex -U $fw -S $out.sam

[ -z "$unpaired" ] && echo "[INFO] [HISAT2] ["`date "+%Y/%m/%d-%H:%M:%S"`"] $HISAT -q --dta -p $nthreads -x $HISATIndex -1 $fw -2 $rw -S $out.sam" && $HISAT -q --dta -p $nthreads -x $HISATIndex -1 $fw -2 $rw -S $out.sam

echo "[INFO] [HISAT2] ["`date "+%Y/%m/%d-%H:%M:%S"`"] sorting, indexing, and optimization ... $out.sam -> $out.bam"
$samtools sort -@ $nthreads -o $out.bam $out.sam
#mv $out.bam ${out}_tmp.bam
#$java -jar $jar ${out}_tmp.bam $out.bam
rm $out.sam #${out}_tmp.bam
$samtools index -b -@ $nthreads $out.bam $out.bam.bai

echo "[INFO] [HISAT] ["`date "+%Y/%m/%d-%H:%M:%S"`"] Finished processing $out"$'\n'
