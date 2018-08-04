
pattern=t7
basepath=
out=dump/feats.scp

. utils/parse_options.sh

dir=$1

if [ $# != 1 ]; then
    echo "Usage: $0 <dir>";
    exit 1;
fi

find -L ${dir} -name *.${pattern} -exec sh storeline.sh {} ${pattern} ${basepath} ${out} \;