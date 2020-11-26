#!/bin/bash

fw=$1
rw=$2
out=$3
nthreads=$4
indexAppendix=$5
twoPass=$6

STAR='/home/software/STAR/bin/Linux_x86_64_static/STAR'
STARIndex="/home/data/indices/STAR/"$indexAppendix"/INDEX"
samtools='/usr/local/bin/samtools'
java='/home/software/jdk-13.0.1/bin/java'
jar='/home/software/bamCleaner.jar'

[ -f "$out".bam ] && echo "[INFO] [STAR] $out.bam already exists; skipping.."$'\n' && exit

mkdir -p $out
[ -z "$twoPass" ] && echo "[INFO] [STAR] ["`date "+%Y/%m/%d-%H:%M:%S"`\
"] $STAR --genomeDir $STARIndex --readFilesIn $fw $rw --runThreadN $nthreads --outFileNamePrefix $out --readFilesCommand zcat --outFilterMismatchNmax 20 --outSAMstrandField intronMotif --quantMode TranscriptomeSAM" \
 ||\
echo "[INFO] [STAR] ["`date "+%Y/%m/%d-%H:%M:%S"`\
"] $STAR --genomeDir $STARIndex --readFilesIn $fw $rw --runThreadN $nthreads --outFileNamePrefix $out --readFilesCommand zcat --outFilterMismatchNmax 20 --outSAMstrandField intronMotif --twopassMode Basic"

[ -z "$twoPass" ] &&\
 $STAR --genomeDir $STARIndex --readFilesIn $fw $rw --runThreadN $nthreads\
 --outFileNamePrefix $out --readFilesCommand zcat --outFilterMismatchNmax 20\
 --outSAMstrandField intronMotif --quantMode TranscriptomeSAM\
 ||\
 $STAR --genomeDir $STARIndex --readFilesIn $fw $rw --runThreadN $nthreads\
 --outFileNamePrefix $out --readFilesCommand zcat --outFilterMismatchNmax 20\
 --outSAMstrandField intronMotif --twopassMode Basic

echo "[INFO] [STAR] ["`date "+%Y/%m/%d-%H:%M:%S"`"] sorting, indexing, and optimization ..."
$samtools sort -@ $nthreads -o $out.bam $out*.sam
#mv $out.bam ${out}_tmp.bam
#$java -jar $jar ${out}_tmp.bam $out.bam
rm $out*.sam #${out}_tmp.bam
$samtools index -b -@ $nthreads $out.bam $out.bam.bai

echo "[INFO] [STAR] ["`date "+%Y/%m/%d-%H:%M:%S"`"] Finished processing $out"$'\n'

