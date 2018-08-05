#!/bin/bash

pattern=t7
basetext=
outfeats=dump
outtext=
dev=0
utt2spk=0

. utils/parse_options.sh

dir=$1
rm -f ${outfeats}/feats.scp
rm -f ${outtext}/text
rm -f ${outtext}/utt2spk
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
     find -L ${dir} -name *.${pattern} -exec sh store_ft_tx_ut.sh {} ${basefeats} ${basetext} ${outfeats} ${outtext} \;
else
     find -L ${dir} -name *.${pattern} | head -${dev} | xargs -I {} sh store_ft_tx_ut.sh {} ${basefeats} ${basetext} ${outfeats} ${outtext}
fi
