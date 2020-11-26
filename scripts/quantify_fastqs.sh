#!/bin/bash

HISAT='/home/scripts/hisat_call.sh'
STAR='/home/scripts/star_call.sh'
STARcompare='/home/scripts/star_compare_call.sh'
kallisto='/home/scripts/kallisto_call.sh'

sampleDir=$1
sampleList=$2
out=$3
nthreads=$4
indexAppendix=$5
unpaired=$6

while read sample; do
	#for tool in $HISAT $STAR $Kallisto $Salmon $Stringtie; do
	#	$tool ...
	#done;

	#HISAT
	mkdir -p $out/HISAT/dta/
	$HISAT $sampleDir/${sample}_1.fastq.gz $sampleDir/${sample}_2.fastq.gz\
		 $out/HISAT/dta/$sample $nthreads $indexAppendix $unpaired
	#--dta --dta reports alignments tailored for transcript assemblers
	#needs complete name of outFile -> /home/data/out/small.sample_01

	#STAR
	$STAR $sampleDir/${sample}_1.fastq.gz $sampleDir/${sample}_2.fastq.gz\
		 $out/STAR/2pass/$sample $nthreads $indexAppendix --twopass
	$STAR $sampleDir/${sample}_1.fastq.gz $sampleDir/${sample}_2.fastq.gz\
		 $out/STAR/quant/$sample $nthreads $indexAppendix

	#$STAR $sampleDir/${sample}_1.fastq.gz $sampleDir/${sample}_2.fastq.gz\
	#	 $out/STAR/quant/$sample $nthreads $indexAppendix $unpaired
	#--twopass runs star in the twopassMode; if not set runs --quantMode TranscriptomeSAM
	# 	--quantMode TranscriptomeSAM ... output SAM/BAM alignments to transcriptome into a separate file
	#needs complete name of outFile -> /home/data/out/small.sample_01

	#Kallisto
	$kallisto $sampleDir/${sample}_1.fastq.gz $sampleDir/${sample}_2.fastq.gz\
		 $out/KALLISTO/alignment/$sample $nthreads $indexAppendix $out/KALLISTO/pseudo/$sample $unpaired

done < $sampleList
