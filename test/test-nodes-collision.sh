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

echo "####COMMAND Two star node graph"
$DN > x1 2> x2 <<EOF
---
nodes:
  - label: one
  - label: two
  - label: three
  - label: four
  - label: five
  - label: six
  - label: seven
  - label: eight
edges:
  - between: [ one, two ]
  - between: [ one, three ]
  - between: [ one, five ]
  - between: [ one, seven ]
  - between: [ two, four ]
  - between: [ two, six ]
  - between: [ two, eight ]
EOF
out $?

) > $(basename $0 .sh).res
