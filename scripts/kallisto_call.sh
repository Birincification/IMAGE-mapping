#!/bin/bash

fw=$1
rw=$2
out=$3
nthreads=$4
indexAppendix=$5
outPseudo=$6
unpaired=$7

[ "$(ls -A $out)" ] && [ "$(ls -A $outPseudo)" ] && echo "[INFO] [KALLISTO] $out && $outPseudo not empty; skipping.."$'\n' && exit

kallisto='/home/software/kallisto_linux-v0.45.0/kallisto'
kallistoIndex="/home/data/indices/kallisto/"$indexAppendix"/INDEX"

quant="$kallisto quant -t $nthreads --index $kallistoIndex --output-dir $out --bias -b 100 $fw $rw"
quantUnpaired="$kallisto quant -t $nthreads --index $kallistoIndex --output-dir $out --bias -b 100 --single $fw"

pseudo="$kallisto pseudo -t $nthreads --index $kallistoIndex --output-dir $outPseudo $fw $rw"
pseudoUnpaired="$kallisto pseudo -t $nthreads --index $kallistoIndex --output-dir $outPseudo --single $fw"

mkdir -p $out
[ -z "$unpaired" ] && echo "[INFO] [KALLISTO] ["`date "+%Y/%m/%d-%H:%M:%S"`"] $quant" && $quant\

[ ! -z "$unpaired" ] && echo "[INFO] [KALLISTO] ["`date "+%Y/%m/%d-%H:%M:%S"`"] $quantUnpaired" && $quantUnpaired

mkdir -p $outPseudo
[ -z "$unpaired" ] && echo "[INFO] [KALLISTO] ["`date "+%Y/%m/%d-%H:%M:%S"`"] $pseudo" && $pseudo \

[ ! -z "$unpaired" ] && echo "[INFO] [KALLISTO] ["`date "+%Y/%m/%d-%H:%M:%S"`"] $pseudoUnpaired" && $pseudoUnpaired

echo "[INFO] [KALLISTO] ["`date "+%Y/%m/%d-%H:%M:%S"`"] Finished processing $out and $outPseudo"$'\n'
