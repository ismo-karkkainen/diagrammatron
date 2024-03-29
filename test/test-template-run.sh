#!/bin/sh

D="../bin/diagrammatron-template"

(
out() {
  echo "####CODE $1"
  echo "####OUT"
  cat x1 | sed "s/^  '/'/g"
  echo "####ERR"
  cat x2 | sed "s/^  '/'/g"
  rm -f x1 x2
}

echo "0" > f0
echo "1" > f1
echo "2" > f2
echo "not_mapping" > invalid
cat > root <<EOF
---
styles:
  diagram:
    default:
      key: value
  node:
    default:
      key: value
  edge:
    default:
      key: value
EOF

echo "####COMMAND Invalid root template file"
$D --root invalid > x1 2> x2
out $?

echo "####COMMAND Valid root but missing fields"
$D --root root > x1 2> x2
out $?

echo "####COMMAND Valid root but unpaired parameters"
$D --root root name f0 unpaired > x1 2> x2
out $?

echo "####COMMAND Valid root and fields"
$D --root root sizes f0 template f1 > x1 2> x2
out $?

echo "####COMMAND Valid root and encoded fields"
$D --root root sizes f0 base64template f1 > x1 2> x2
out $?

echo "####COMMAND Valid root and encoded fields with extra"
$D --output x1 --root root sizes f0 base64template f1 extra f2 2> x2
out $?

rm -f root f0 f1 f2 invalid

) > $(basename $0 .sh).res
