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

echo "####COMMAND L graph"
$DN > x1 2> x2 <<EOF
---
nodes:
  - label: one
    sid: 0
    xo: 0
    yo: 0
  - label: two
    sid: 0
    xo: 1
    yo: 0
  - label: three
    sid: 0
    xo: 0
    yo: 1
edges:
  - between: [ one, three ]
  - between: [ three, two ]
  - between: [ one, two ]
EOF
out $?

echo "####COMMAND T graph"
$DN > x1 2> x2 <<EOF
---
nodes:
  - label: one
    sid: 0
    xo: 0
    yo: 0
  - label: two
    sid: 0
    xo: 1
    yo: 1
  - label: three
    sid: 0
    xo: 2
    yo: 0
edges:
  - between: [ one, three ]
  - between: [ three, two ]
  - between: [ one, two ]
EOF
out $?

echo "####COMMAND Line graph"
$DN > x1 2> x2 <<EOF
---
nodes:
  - label: one
    sid: 0
    xo: 0
    yo: 0
  - label: two
    sid: 0
    xo: 1
    yo: 0
  - label: three
    sid: 0
    xo: 2
    yo: 0
edges:
  - between: [ one, three ]
  - between: [ three, two ]
  - between: [ two, one ]
  - between: [ three, one ]
EOF
out $?

) > $(basename $0 .sh).res
