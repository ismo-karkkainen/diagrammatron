#!/bin/sh

DN="../diagrammatron-place --quiet"

(
out() {
  echo "####CODE $1"
  echo "####OUT"
  cat x1
  echo "####ERR"
  cat x2
  rm -f x1 x2
}

echo "####COMMAND Invalid ratio"
$DN --ratio invalid > x1 2> x2 <<EOF
EOF
out $?

echo "####COMMAND Zero ratio"
$DN --ratio 0 > x1 2> x2 <<EOF
EOF
out $?

echo "####COMMAND Negative ratio"
$DN --ratio -1 > x1 2> x2 <<EOF
EOF
out $?

echo "####COMMAND Three-subset graph"
$DN > x1 2> x2 <<EOF
---
nodes:
- label: oneL
  sid: 0
  xo: 0
  yo: 0
- label: twoL
  sid: 0
  xo: 2
  yo: 0
- label: threeL
  sid: 0
  xo: 0
  yo: 2
- label: oneT
  sid: 1
  xo: 0
  yo: 0
- label: twoT
  sid: 1
  xo: 2
  yo: 2
- label: threeT
  sid: 1
  xo: 4
  yo: 0
- label: one-line
  sid: 2
  xo: 0
  yo: 0
- label: two-line
  sid: 2
  xo: 2
  yo: 0
- label: three-line
  sid: 2
  xo: 4
  yo: 0
edges:
- between:
  - oneL
  - threeL
  path:
  - xo: 0.5
    yo: 0
  - xo: 0.5
    yo: 2
  sid: 0
- between:
  - threeL
  - twoL
  path:
  - xo: 0
    yo: 2.5
  - xo: 2.5
    yo: 2.5
  - xo: 2.5
    yo: 0
  sid: 0
- between:
  - oneL
  - twoL
  path:
  - xo: 0
    yo: 0.5
  - xo: 2
    yo: 0.5
  sid: 0
- between:
  - oneT
  - threeT
  path:
  - xo: 0
    yo: 0.3333333333333333
  - xo: 4
    yo: 0.3333333333333333
  sid: 1
- between:
  - threeT
  - twoT
  path:
  - xo: 4
    yo: 0.6666666666666666
  - xo: 2.6666666666666665
    yo: 0.6666666666666666
  - xo: 2.6666666666666665
    yo: 2
  sid: 1
- between:
  - oneT
  - twoT
  path:
  - xo: 0
    yo: 0.6666666666666666
  - xo: 2.3333333333333335
    yo: 0.6666666666666666
  - xo: 2.3333333333333335
    yo: 2
  sid: 1
- between:
  - one-line
  - three-line
  path:
  - xo: 0.6666666666666666
    yo: 0
  - xo: 0.6666666666666666
    yo: 1.3333333333333333
  - xo: 4.333333333333333
    yo: 1.3333333333333333
  - xo: 4.333333333333333
    yo: 0
  sid: 2
- between:
  - three-line
  - two-line
  path:
  - xo: 4
    yo: 0.5
  - xo: 2
    yo: 0.5
  sid: 2
- between:
  - two-line
  - one-line
  path:
  - xo: 2
    yo: 0.5
  - xo: 0
    yo: 0.5
  sid: 2
- between:
  - three-line
  - one-line
  path:
  - xo: 4.666666666666667
    yo: 0
  - xo: 4.666666666666667
    yo: 1.6666666666666665
  - xo: 0.3333333333333333
    yo: 1.6666666666666665
  - xo: 0.3333333333333333
    yo: 0
  sid: 2
EOF
out $?

echo "####COMMAND Three-subset graph with ratio"
$DN --ratio 20.0 > x1 2> x2 <<EOF
---
nodes:
- label: oneL
  sid: 0
  xo: 0
  yo: 0
- label: twoL
  sid: 0
  xo: 2
  yo: 0
- label: threeL
  sid: 0
  xo: 0
  yo: 2
- label: oneT
  sid: 1
  xo: 0
  yo: 0
- label: twoT
  sid: 1
  xo: 2
  yo: 2
- label: threeT
  sid: 1
  xo: 4
  yo: 0
- label: one-line
  sid: 2
  xo: 0
  yo: 0
- label: two-line
  sid: 2
  xo: 2
  yo: 0
- label: three-line
  sid: 2
  xo: 4
  yo: 0
edges:
- between:
  - oneL
  - threeL
  path:
  - xo: 0.5
    yo: 0
  - xo: 0.5
    yo: 2
  sid: 0
- between:
  - threeL
  - twoL
  path:
  - xo: 0
    yo: 2.5
  - xo: 2.5
    yo: 2.5
  - xo: 2.5
    yo: 0
  sid: 0
- between:
  - oneL
  - twoL
  path:
  - xo: 0
    yo: 0.5
  - xo: 2
    yo: 0.5
  sid: 0
- between:
  - oneT
  - threeT
  path:
  - xo: 0
    yo: 0.3333333333333333
  - xo: 4
    yo: 0.3333333333333333
  sid: 1
- between:
  - threeT
  - twoT
  path:
  - xo: 4
    yo: 0.6666666666666666
  - xo: 2.6666666666666665
    yo: 0.6666666666666666
  - xo: 2.6666666666666665
    yo: 2
  sid: 1
- between:
  - oneT
  - twoT
  path:
  - xo: 0
    yo: 0.6666666666666666
  - xo: 2.3333333333333335
    yo: 0.6666666666666666
  - xo: 2.3333333333333335
    yo: 2
  sid: 1
- between:
  - one-line
  - three-line
  path:
  - xo: 0.6666666666666666
    yo: 0
  - xo: 0.6666666666666666
    yo: 1.3333333333333333
  - xo: 4.333333333333333
    yo: 1.3333333333333333
  - xo: 4.333333333333333
    yo: 0
  sid: 2
- between:
  - three-line
  - two-line
  path:
  - xo: 4
    yo: 0.5
  - xo: 2
    yo: 0.5
  sid: 2
- between:
  - two-line
  - one-line
  path:
  - xo: 2
    yo: 0.5
  - xo: 0
    yo: 0.5
  sid: 2
- between:
  - three-line
  - one-line
  path:
  - xo: 4.666666666666667
    yo: 0
  - xo: 4.666666666666667
    yo: 1.6666666666666665
  - xo: 0.3333333333333333
    yo: 1.6666666666666665
  - xo: 0.3333333333333333
    yo: 0
  sid: 2
EOF
out $?

) > $(basename $0 .sh).res
