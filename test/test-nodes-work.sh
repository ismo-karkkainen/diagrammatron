#!/bin/sh

DN="../diagrammatron-nodes --algorithm vertical"

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
$DN > x1 2> x2 <<EOF
---
nodes:
  - label: one
EOF
out $?

echo "####COMMAND Node missing a label"
$DN > x1 2> x2 <<EOF
---
nodes:
  - label: unused
  - missing: label
EOF
out $?

echo "####COMMAND Missing node and too few/many end-points"
$DN > x1 2> x2 <<EOF
---
nodes:
  - label: one
edges:
  - between: [ one ]
  - between: [ two, two ]
  - between: [ one, two, three ]
EOF
out $?

echo "####COMMAND Various edges"
$DN > x1 2> x2 <<EOF
---
nodes:
  - label: one
  - label: unconnected
  - label: two
edges:
  - between: [ one, one ]
  - ignored: betweenless
  - between: []
  - between: [ one, two ]
EOF
out $?

) > $(basename $0 .sh).res
