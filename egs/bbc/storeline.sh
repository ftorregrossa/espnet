line=$1
pattern=$2
basepath=$3
outfile=$4

export DIRECTORY=`dirname ${line} | cut -c3-`
export FILENAME=`basename ${line} .${pattern}`
export ID=`echo ${DIRECTORY}/${FILENAME} | sed -r 's/[/]+/-/g'`

if [ ${pattern} == "txt" ]; then
    export CONTENT=`cat ${line} | grep Text | cut -c8-`
else
    export CONTENT=${basepath}/${DIRECTORY}/${FILENAME}.${pattern}
fi

echo ${ID}  ${CONTENT} >> ${outfile}