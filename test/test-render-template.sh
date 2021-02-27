#!/bin/sh

D="../diagrammatron-render"

(
out() {
  echo "####CODE $1"
  echo "####OUT"
  cat x1
  echo "####ERR"
  cat x2
  rm -f x1 x2
}

echo "####COMMAND Invalid base64 template field"
cat > t <<EOF
---
base64bad: "zxcvgbhjnk"
EOF
$D --template t > x1 2> x2 <<EOF
---
nodes: []
EOF
out $?
rm -f t

) > $(basename $0 .sh).res
