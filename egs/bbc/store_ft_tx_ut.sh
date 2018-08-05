#!/bin/bash

line=$1
basetext=$2
outfeats=$3
outtext=$4

sh storeline.sh $1 t7 "" ${outfeats}/feats.scp 0
sh storeline.sh $1 txt ${basetext} ${outtext}/text 0
sh storeline.sh $1 txt ${basetext} ${outtext}/utt2spk 1