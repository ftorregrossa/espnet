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
propvalid="0.8"

. utils/parse_options.sh || exit 1;

mkdir -p ${dump}
mkdir -p ${trans}
mkdir -p ${all}
mkdir -p ${langdir}
if [ ${dev} -eq 0 ]; then
        devpath=
else
	echo "<<-- DEV MODE -->>"
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

echo "Start preprocessing"
echo "-- Making scp files"
mkdir -p ${all}/train
mkdir -p ${all}/valid
mkdir -p ${trans}/train
mkdir -p ${trans}/valid
# make scps
./make_scp.sh --propvalid ${propvalid} --pattern t7 --basetext $2 --outfeats ${all} --outtext ${trans} --dev ${dev} $1
# echo "-- > Making text scp files"
# ./make_scp.sh --pattern txt --basepath ${basepath} --out ${trans}/text --dev ${dev} $2
# echo "-- > Making utt2spk scp files"
# ./make_scp.sh --pattern txt --basepath ${basepath} --out ${trans}/utt2spk --dev ${dev} --utt2spk 1 $2

echo "Find tokens"
dict=${langdir}/tr_units.txt
echo "dictionary: ${dict}"

### Task dependent. You have to check non-linguistic symbols used in the corpus.
echo "Dictionary and Json Data Preparation"

echo "<unk> 1" > ${dict} # <unk> must be 1, 0 will be used for "blank" in CTC
cat ${trans}/train/text ${trans}/valid/text | text2token.py -s 1 -n 1 | cut -f 2- -d" " | tr " " "\n" \
| sort | uniq | grep -v -e '^\s*$' | awk '{print $0 " " NR+1}' >> ${dict}
wc -l ${dict}

# make json labels
echo "Making JSON file (training)"
data2json.sh --lang ${lang} --feat ${all}/train/feats.scp --tensor 1\
        ${trans}/train ${dict} > ${all}/train/data.json
echo "Making JSON file (validation)"
data2json.sh --lang ${lang} --feat ${all}/valid/feats.scp --tensor 1\
        ${trans}/valid ${dict} > ${all}/valid/data.json
