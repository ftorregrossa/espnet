#!/bin/bash

pattern=t7
basepath=
out=dump/feats.scp
dev=0

. utils/parse_options.sh

dir=$1
echo $#
if [ $# != 1 ]; then
    echo "Usage: $0 <dir>";
    exit 1;
fi

if [${dev} -eq 0]; then
    find -L ${dir} -name *.${pattern} -exec sh storeline.sh {} ${pattern} ${basepath} ${out} \;
else
    find -L ${dir} -name *.${pattern} | head -1000 | xargs -I {} sh storeline.sh {} ${pattern} ${basepath} ${out} 
fi