#!/bin/bash

line=$1
basetext=$2
outfeats=$3
outtext=$4
propvalid=$5

printf "current file: $line \r"
export CHOICE=`shuf -i 1-1000 -n 1`
if [ $CHOICE -le ${propvalid} ]; then
    sh storeline.sh $1 t7 t7 "" ${outfeats}/train/feats.scp 0
    sh storeline.sh $1 t7 txt ${basetext} ${outtext}/train/text 0
    sh storeline.sh $1 t7 txt ${basetext} ${outtext}/train/utt2spk 1
else
    sh storeline.sh $1 t7 t7 "" ${outfeats}/valid/feats.scp 0
    sh storeline.sh $1 t7 txt ${basetext} ${outtext}/valid/text 0
    sh storeline.sh $1 t7 txt ${basetext} ${outtext}/valid/utt2spk 1
fi
