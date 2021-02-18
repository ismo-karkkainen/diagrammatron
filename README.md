# Diagrammatron

This is a small collection to programs to do the following:
- Convert a dot_json file to diagrammatron format.
- Prune nodes and attached edges from the diagram.
- Place the nodes of a graph/diagram onto a plane.
- Place edges between the nodes.
- Place separate sub-diagrams so that they do not overlap.
- Turn the resulting graph into a graphics file for viewing.

All stages are separate programs. Input file can contain information for
later stages as each stage only considers the part it needs and other
information is passed through as is.

If you have a GraphViz dot file, you can convert it using GraphViz dot tool:

    dot -Tdot_json -odiagram.json diagram.dot

Only the node names and edge end-point information is used.

# Programs

You should call the programs in the following order, as needed.

* dot_json2diagrammatron converts from dot_json to diagrammtron format.
* diagrammetron-prune removes or retains nodes/edges from diagram.
* diagrammatron-nodes places nodes inside sub-diagrams based on distances.
* diagrammatron-edges places edges within sub-diagrams when nodes are placed.
* diagrammatron-place places sub-diagrams so that they do not overlap.
* diagrammatron-svg takes the previous output and outputs a svg file.

Unless you need to make changes, you can pipe the output of previous to the
next one, such as:

    dot_json2diagrammatron -i diagram.json | diagrammatron-nodes | diagrammatron-edges | diagrammatron-place | diagrammatron-svg -o diagram.svg

Using diagrammatron-prune can be followed e.g. by sed with various expressions
to modify node labels by getting rid of repetitive elements, if such are
present. If source is a graph produced by Terraform, you can get rid of the
local values and providers as uninteresting and clean node labels via:

    diagrammatron-prune -i input.yaml ' provider' ' local.' 'meta.count-boundary' | sed -e 's/.root. //g' -e 's/ .expand.//g' > output.yaml

# Requirements

You need Ruby 2.5 or newer. Only standard library packages are used.

# Testing and installing

To run tests, run:

    rake test

To install, by default to /usr/local/bin (export PREFIX=path to change), run:

    sudo rake install

Directory test/port contains scripts that are used to run tests on various
operating systems. Each script is named after what uname returns on the OS
in question. Essentially these install some packages and then run all tests.

# License

Copyright (C) 2021 Ismo Kärkkäinen

Licensed under Universal Permissive License. See License.txt.
