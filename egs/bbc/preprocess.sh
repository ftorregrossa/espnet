#!/bin/bash

. ./path.sh
. ./cmd.sh

basepath=
lang="en"
all=data/all

. utils/parse_options.sh

echo "Start preprocessing"
mkdir -p dump
mkdir -p data/tr

echo "-- Making scp files"
# make scps
make_scp.sh $1 --pattern t7 --basepath ${basepath} --out ${all}/feats.scp
make_scp.sh $2 --pattern txt --basepath ${basepath} --out data/tr/text

echo "Find tokens"
dict=data/lang_1char/tr_units.txt
echo "dictionary: ${dict}"

### Task dependent. You have to check non-linguistic symbols used in the corpus.
echo "Dictionary and Json Data Preparation"
mkdir -p data/lang_1char/
echo "<unk> 1" > ${dict} # <unk> must be 1, 0 will be used for "blank" in CTC
text2token.py -s 1 -n 1 data/tr/text | cut -f 2- -d" " | tr " " "\n" \
| sort | uniq | grep -v -e '^\s*$' | awk '{print $0 " " NR+1}' >> ${dict}
wc -l ${dict}

# make json labels
data2json.sh --lang ${lang} --feat ${all}/feats.scp \
        data/tr ${dict} > ${all}/data.json
