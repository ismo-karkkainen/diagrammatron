#!/bin/sh

DN="../diagrammatron-nodes --algorithm pathlength"

(
out() {
echo "####CODE $1"
echo "####OUT"
cat x1
echo "####ERR"
cat x2
rm -f x1 x2
}

echo "####COMMAND Two node graph"
$DN > x1 2> x2 <<EOF
---
nodes:
  - label: one
  - label: two
edges:
  - between: [ one, two ]
EOF
out $?

echo "####COMMAND Two node unconnected graph"
$DN > x1 2> x2 <<EOF
---
nodes:
  - label: one
  - label: two
EOF
out $?

echo "####COMMAND Three node split graph"
$DN > x1 2> x2 <<EOF
---
nodes:
  - label: one
  - label: two
  - label: three
edges:
  - between: [ one, two ]
EOF
out $?

echo "####COMMAND Three node graph"
$DN > x1 2> x2 <<EOF
---
nodes:
  - label: one
  - label: two
  - label: three
edges:
  - between: [ one, two ]
  - between: [ one, three ]
EOF
out $?

echo "####COMMAND Five node graph"
$DN > x1 2> x2 <<EOF
---
nodes:
  - label: one
  - label: two
  - label: three
  - label: four
  - label: five
edges:
  - between: [ one, two ]
  - between: [ one, three ]
  - between: [ four, three ]
  - between: [ four, five ]
  - between: [ four, two ]
EOF
out $?

) > $(basename $0 .sh).res
