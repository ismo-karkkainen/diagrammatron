#!/bin/sh

DN="../bin/diagrammatron-edges"

(
out() {
  echo "####CODE $1"
  echo "####OUT"
  cat x1
  echo "####ERR"
  cat x2
  rm -f x1 x2
}

echo "####COMMAND Right side"
$DN > x1 2> x2 <<EOF
---
nodes:
  - label: one
    sid: 0
    xo: 0
    yo: 2
  - label: top
    sid: 0
    xo: 1
    yo: 4
  - label: up
    sid: 0
    xo: 1
    yo: 3
  - label: middle
    sid: 0
    xo: 1
    yo: 2
  - label: down
    sid: 0
    xo: 1
    yo: 1 
  - label: bottom
    sid: 0
    xo: 1
    yo: 0
edges:
  - between: [ one, top ]
  - between: [ one, up ]
  - between: [ one, middle ]
  - between: [ one, down ]
  - between: [ one, bottom ]
EOF
out $?

) > $(basename $0 .sh).res
