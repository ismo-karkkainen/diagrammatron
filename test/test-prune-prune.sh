#!/bin/sh

D="../bin/diagrammatron-prune"

(
out() {
  echo "####CODE $1"
  echo "####OUT"
  cat x1
  echo "####ERR"
  cat x2
  rm -f x1 x2
}

echo "####COMMAND Prune one."
$D -o x1 one 2> x2 <<EOF
---
nodes:
- label: one
- label: two
- label: three
edges:
- between: [ one, two ]
- between: [ two, three ]
- between: [ three, one ]
EOF
out $?

echo "####COMMAND Prune three one."
$D -o x1 one three 2> x2 <<EOF
---
nodes:
- label: one
- label: two
- label: three
edges:
- between: [ one, two ]
- between: [ two, three ]
- between: [ three, one ]
EOF
out $?

echo "####COMMAND Keep one."
$D -o x1 -r one 2> x2 <<EOF
---
nodes:
- label: one
- label: two
- label: three
edges:
- between: [ one, two ]
- between: [ two, three ]
- between: [ three, one ]
EOF
out $?

echo "####COMMAND Keep three one."
$D -o x1 -r one three 2> x2 <<EOF
---
nodes:
- label: one
- label: two
- label: three
edges:
- between: [ one, two ]
- between: [ two, three ]
- between: [ three, one ]
EOF
out $?

) > $(basename $0 .sh).res
