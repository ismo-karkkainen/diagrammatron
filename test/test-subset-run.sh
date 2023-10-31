#!/bin/sh

D="../bin/diagrammatron-subset"

(
out() {
  echo "####CODE $1"
  shift
  echo "####OUT"
  cat x1
  echo "####ERR"
  cat x2
  rm -f x1 x2 $*
}

echo "####COMMAND No selected"
$D > x1 2> x2 <<EOF
---
nodes: []
EOF
out $?

echo "####COMMAND Selected not in rules"
$D --select undefined > x1 2> x2 <<EOF
---
nodes: []
EOF
out $?

echo "####COMMAND Rule file load failure"
$D --select exp missing > x1 2> x2 <<EOF
---
nodes: []
EOF
out $?

echo "####COMMAND No edges or nodes"
cat > rf <<EOF
---
expressions:
- name: exp
  expression: set
sets:
- name: set
  nodes:
  - name: field
    rules:
    - matching
EOF
$D --select exp rf > x1 2> x2 <<EOF
---
nodes: []
EOF
out $? rf

echo "####COMMAND Graph"
cat > rf <<EOF
---
expressions:
- name: exp
  expression: set
sets:
- name: set
  nodes:
  - name: field
    rules:
    - matching
  edges:
  - name: afield
    rules:
    - similar
EOF
$D --select set rf > x1 2> x2 <<EOF
---
nodes:
- label: a
  field: matching
- label: b
- label: c
  field: "also matching"
edges:
- between: [ a, b ]
- between: [ c, b ]
  afield: similar
- between: [ a, c ]
  afield: similar
EOF
out $? rf

) > $(basename $0 .sh).res
