#!/bin/bash

. ./path.sh
. ./cmd.sh

basepath=
lang="en"
all=data/all
dev=0
trans=data/tr
dump=dump
langdir=data/lang_1char

. utils/parse_options.sh || exit 1;

echo "Start preprocessing"

mkdir -p ${dump}
mkdir -p ${trans}
mkdir -p ${all}
mkdir -p ${langdir}
echo ${dev}
echo ${basepath}
if [ ${dev} -eq 0 ]; then
        devpath=
else
	echo "DEV MODE"
        devpath=dev
        
        all=${all}/dev
        mkdir -p ${all}

        trans=${trans}/dev
        mkdir -p ${trans}

        dump=${dump}/dev
        mkdir -p ${dump}

        lang=${langdir}/dev
        mkdir -p ${langdir}
fi

echo "-- Making scp files"
# make scps
echo "-- > Making features scp files"
./make_scp.sh --pattern t7 --basepath ${basepath} --out ${all}/feats.scp --dev ${dev} $1
echo "-- > Making text scp files"
./make_scp.sh --pattern txt --basepath ${basepath} --out ${trans}/text --dev ${dev} $2

echo "Find tokens"
dict=${langdir}/tr_units.txt
echo "dictionary: ${dict}"

### Task dependent. You have to check non-linguistic symbols used in the corpus.
echo "Dictionary and Json Data Preparation"

echo "<unk> 1" > ${dict} # <unk> must be 1, 0 will be used for "blank" in CTC
text2token.py -s 1 -n 1 ${trans}/text | cut -f 2- -d" " | tr " " "\n" \
| sort | uniq | grep -v -e '^\s*$' | awk '{print $0 " " NR+1}' >> ${dict}
wc -l ${dict}

# make json labels
data2json.sh --lang ${lang} --feat ${all}/feats.scp \
        ${trans} ${dict} > ${all}/data.json
