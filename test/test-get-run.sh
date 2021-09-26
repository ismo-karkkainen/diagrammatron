#!/bin/sh

D="../bin/diagrammatron-get"

(
out() {
  echo "####CODE $1"
  echo "####OUT"
  cat x1
  echo "####ERR"
  cat x2
  rm -f x1 x2
}

echo "####COMMAND List templates"
$D > x1 2> x2
out $?

echo "####COMMAND Get existing file"
$D root.yaml > x1 2> x2
out $?

echo "####COMMAND Get invalid file"
$D lmay.toor > x1 2> x2
out $?

echo "####COMMAND Save existing file"
$D --output x3 internal.yaml > x1 2> x2
out $?

echo "####COMMAND Compare saved and existing"
diff x3 ../template/internal.yaml > x1 2> x2
out $?

rm -f x3

echo "####COMMAND Too many file names"
$D internal.yaml root.yaml > x1 2> x2
out $?

echo "####COMMAND Invalid output file name"
$D root.yaml --output ./in/valid > x1 2> x2
out $?

) > $(basename $0 .sh).res
