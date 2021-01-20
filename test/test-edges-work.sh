#!/bin/sh

DN="../diagrammatron-edges"

(
out() {
  echo "####CODE $1"
  echo "####OUT"
  cat x1
  echo "####ERR"
  cat x2
  rm -f x1 x2
}

echo "####COMMAND One node graph without sid"
$DN > x1 2> x2 <<EOF
---
nodes:
  - label: one
EOF
out $?

echo "####COMMAND One node graph without coordinates"
$DN > x1 2> x2 <<EOF
---
nodes:
  - label: one
    sid: 0
EOF
out $?

echo "####COMMAND One node graph without yo"
$DN > x1 2> x2 <<EOF
---
nodes:
  - label: one
    xo: 0
    sid: 0
EOF
out $?

echo "####COMMAND Node missing a label"
$DN > x1 2> x2 <<EOF
---
nodes:
  - label: unused
    sid: 0
    xo: 0
    yo: 0
  - sid: 0
    xo: 0
    yo: 0
EOF
out $?

echo "####COMMAND Missing node and too few/many end-points"
$DN > x1 2> x2 <<EOF
---
nodes:
  - label: one
    sid: 0
    xo: 0
    yo: 0
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
    sid: 0
    xo: 0
    yo: 0
  - label: unconnected
    sid: 1
    xo: 0
    yo: 0
  - label: two
    sid: 0
    xo: 1
    yo: 0
edges:
  - between: [ one, one ]
  - ignored: betweenless
  - between: []
  - between: [ one, two ]
EOF
out $?

) > $(basename $0 .sh).res
