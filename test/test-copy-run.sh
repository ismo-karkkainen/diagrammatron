#!/bin/sh

DN="../bin/diagrammatron-copy"

(
out() {
echo "####CODE $1"
echo "####OUT"
cat x1
echo "####ERR"
cat x2
rm -f x1 x2
}

echo "####COMMAND One node graph"
$DN label dst > x1 2> x2 <<EOF
---
nodes:
  - label: one
EOF
out $?

echo "####COMMAND Multiple pairs"
$DN src dst src2 dst2 > x1 2> x2 <<EOF
---
nodes:
  - label: one
    src2: source2
  - label: two
    dst: stays
  - label: three
    dst2: remains
edges:
  - between: [ one, two ]
    src: source
  - between: [ two, three ]
    src2: wipes
    dst2: overwrite
  - between: [ one, three ]
EOF
out $?

) > $(basename $0 .sh).res
