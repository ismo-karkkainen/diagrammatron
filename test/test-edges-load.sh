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

echo "####COMMAND Empty piped input"
echo | $DN > x1 2> x2
out $?

echo "####COMMAND Empty file input"
touch tmp
$DN -i tmp > x1 2> x2
out $?
rm -f tmp

echo "####COMMAND Missing input file"
$DN -i tmp > x1 2> x2
out $?

echo "####COMMAND Bad piped input"
echo "error" | $DN > x1 2> x2
out $?

) > $(basename $0 .sh).res
