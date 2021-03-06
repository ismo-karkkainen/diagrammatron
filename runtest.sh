#!/bin/sh

P="./test-*.sh"
if [ $# -ne 0 ]; then
    P="./test-$1-*.sh"
fi

RV=0
cd test
for S in $P
do
    echo $S
    $S
    B=$(basename $S .sh)
    if [ ! -f $B.good ]; then
        echo "No $B.good to compare with."
        continue
    fi
    ./compare $B.good $B.res
    if [ $? -eq 0 ]; then
        echo "Comparison ok."
    else
        RV=1
    fi
done
exit $RV
