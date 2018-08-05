#!/bin/bash

line=$1
basepattern=$2
pattern=$3
basepath=$4
outfile=$5
utt2spk=$6

export DIRECTORY=`dirname ${line} | cut -c2-`
export FILENAME=`basename ${line} .${basepattern}`
export SUBJECT=`basename ${DIRECTORY}`
export TYPELOC=`dirname ${DIRECTORY}`
export TYPELOC=`basename ${TYPELOC}`
export ID=`echo ${TYPELOC}/${SUBJECT}/${FILENAME} | sed -r 's/[/]+/-/g'`

if [ ${utt2spk} -eq 0 ]; then
    if [ "${pattern}" = "txt" ]; then
        export TXTFILE=${basepath}/${TYPELOC}/${SUBJECT}/${FILENAME}.${pattern}
        export CONTENT="`cat ${TXTFILE} | grep Text | cut -c8-`"
    else
        export CONTENT=/${DIRECTORY}/${FILENAME}.${pattern}
    fi
else
    export CONTENT=`basename ${DIRECTORY}`
fi

echo ${ID}  ${CONTENT} >> ${outfile}
