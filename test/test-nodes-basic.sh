#!/bin/sh

DN="../diagrammatron-nodes"

(
echo "####COMMAND Empty piped input"
echo | $DN > x1 2> x2
echo "####CODE $?"
echo "####OUT"
cat x1
echo "####ERR"
cat x2

echo "####COMMAND Empty file input"
touch tmp
$DN -i tmp > x1 2> x2
echo "####CODE $?"
echo "####OUT"
cat x1
echo "####ERR"
cat x2
rm -f tmp

echo "####COMMAND Missing input file"
$DN -i tmp > x1 2> x2
echo "####CODE $?"
echo "####OUT"
cat x1
echo "####ERR"
cat x2

echo "####COMMAND Bad piped input"
echo "error" | $DN > x1 2> x2
echo "####CODE $?"
echo "####OUT"
cat x1
echo "####ERR"
cat x2

echo "####COMMAND Unrecognized algorithm"
$DN -i tmp -a unknown > x1 2> x2
echo "####CODE $?"
echo "####OUT"
cat x1
echo "####ERR"
cat x2

) > $(basename $0 .sh).res

rm -f x1 x2
