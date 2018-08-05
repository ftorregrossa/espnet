#!/bin/bash

propvalid=800
pattern=t7
basetext=
outfeats=dump
outtext=
dev=0
utt2spk=0
nproc=1

. utils/parse_options.sh

dir=$1
rm -f ${outfeats}/train/feats.scp
rm -f ${outfeats}/valid/feats.scp
rm -f ${outtext}/train/text
rm -f ${outtext}/valid/text
rm -f ${outtext}/train/utt2spk
rm -f ${outtext}/valid/utt2spk
echo "-- >> in " $1
if [ $# != 1 ]; then
    echo "Usage: $0 <dir>";
    exit 1;
fi

# if [ ${dev} -eq 0 ]; then
#     find -L ${dir} -name *.${pattern} -exec sh storeline.sh {} ${pattern} ${basepath} ${out} ${utt2spk} \;
# else
#     find -L ${dir} -name *.${pattern} | head -10 | xargs -I {} sh storeline.sh {} ${pattern} ${basepath} ${out} ${utt2spk}
# fi

if [ ${dev} -eq 0 ]; then 
     find -L ${dir} -name *.${pattern} | xargs -P ${nproc} -I {} sh store_ft_tx_ut.sh {} ${basefeats} ${basetext} ${outfeats} ${outtext} ${propvalid}
else
     find -L ${dir} -name *.${pattern} | head -${dev} | xargs -P ${nproc} -I {} sh store_ft_tx_ut.sh {} ${basefeats} ${basetext} ${outfeats} ${outtext} ${propvalid}
fi
printf "SCP preprocessing terminated                                                                                                                   \r\n"
