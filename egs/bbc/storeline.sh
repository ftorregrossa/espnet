#!/bin/bash

line=$1
pattern=$2
basepath=$3
outfile=$4
utt2spk=$5

export DIRECTORY=`dirname ${line} | cut -c2-`
export FILENAME=`basename ${line} .${pattern}`
export ID=`echo ${DIRECTORY}/${FILENAME} | sed -r 's/[/]+/-/g'`

if [ ${utt2spk} -eq 0 ]; then
    if [ "${pattern}" = "txt" ]; then
        export SUBJECT=`basename ${DIRECTORY}`
        export TYPELOC=`dirname ${DIRECTORY}`
        export TYPELOC=`basename ${TYPELOC}`
        export TXTFILE=${basepath}/${TYPELOC}/${SUBJECT}/${FILENAME}
        export CONTENT="`cat ${TXTFILE} | grep Text | cut -c8-`"
    else
        export CONTENT=/${DIRECTORY}/${FILENAME}.${pattern}
    fi
else
    export CONTENT=`basename ${DIRECTORY}`
fi

echo ${ID}  ${CONTENT} >> ${outfile}
