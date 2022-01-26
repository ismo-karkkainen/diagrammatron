# Diagrammatron

This is a small collection to programs to do the following:
- Convert a dot_json file to diagrammatron format.
- Prune nodes and attached edges from the diagram.
- Place the nodes of a graph/diagram onto a plane.
- Place edges between the nodes.
- Place separate sub-diagrams so that they do not overlap.
- Turn the resulting graph into a graphics file for viewing.
- A helper script to make it easier to construct templates for conversion.

All stages are separate programs. Input file can contain information for
later stages as each stage only considers the part it needs and other
information is passed through as is.

If you have a GraphViz dot file, you can convert it using GraphViz dot tool:

    dot -Tdot_json -odiagram.json diagram.dot

Only the node names and edge end-point information is used.

# Programs

You should call the programs in the following order, as needed.

* diagrammatron-get extracts template files from the gem.
* dot_json2diagrammatron converts from dot_json to diagrammtron format.
* diagrammatron-prune removes or retains nodes/edges from diagram.
* diagrammatron-nodes places nodes inside sub-diagrams based on distances.
* diagrammatron-edges places edges within sub-diagrams when nodes are placed.
* diagrammatron-place places sub-diagrams so that they do not overlap.
* diagrammatron-render takes the previous output and outputs a file.
* diagrammatron-template can combine multiple files into a render template.

Unless you need to make changes, you can pipe the output of previous to the
next one, such as:

    dot_json2diagrammatron -i diagram.json | diagrammatron-nodes | diagrammatron-edges | diagrammatron-place | diagrammatron-render -t internal.yaml -o diagram.svg

Using diagrammatron-prune can be followed e.g. by sed with various expressions
to modify node labels by getting rid of repetitive elements, if such are
present. If source is a graph produced by Terraform, you can get rid of the
local values and providers as uninteresting and clean node labels via:

    diagrammatron-prune -i input.yaml ' provider' ' local.' 'meta.count-boundary' | sed -e 's/.root. //g' -e 's/ .expand.//g' > output.yaml

All programs are designed to retain the source fields that they do not use.

## diagrammatron-get

Allows obtaining the templates stored in the gem. Removes the need to clone
the source code repository.

To get the internal.yaml used in the examples, run:

    diagrammatron-get internal.yaml --output internal.yaml

Running the program without arguments lists the available files.

It may appear inconvenient to extract files before they can be used but at
this point the assumption is that you should modify the template that produces
the SVG output.

## dot_json2diagrammatron

For nodes, tries to get first "name", then "label" and if neither are present,
defaults to "node N" where N is the index of the node in the source array,
and stores it in "label".

For edges, stores the node labels of "head" and "tail" in "between".

## diagrammatron-prune

Looks for given patterns in node labels and removes those. Removes the edges
as well so that the diagram remains intact. Use with sed to rename the nodes
that remain for cleaner output.

## diagrammatron-nodes

Finds connected sub-diagrams and assigns nodes locations to "xo" and "yo"
fields. A couple simple algorithms are available. Coordinates indicate the
ordering of nodes and not where they should actually be located. Disjoint
sub-diagrams will be placed on top of each other.

## diagrammatron-edges

Places edges between nodes within each connected sub-diagram by removing
candidates that have most crossings. Each edges has only horizontal and
vertical segments with 90-degree angles.

Currently uses very slow depth-first search to determine the order of edge
segments with regard to each other when they are in same gap between nodes.

## diagrammatron-place

Places disjoint sub-diagrams in relation to each other so that they do not
overlap. The bounding rectangle side lengths are monimized. The width to height
ratio of the nodes can be taken into account using --ratio parameter. All
nodes are considered point-like at this stage. Not using ratio will probably
result in elongated output from diagrammatron-render.

## diagrammatron-render

Takes a template and uses it to produce an image file. The file is in YAML
format. The internal.yaml provided in this repository produces SVG 1.1 file.

Nodes are expected to have a field names "style" that defaults to "default"
if missing. The style is used to find a function that assigns width and height
to the node before final sizes are assigned. The algorithm at this point relies
on each column having nodes of equal width and each row having nodes of equal
height. Consequently only rectangular nodes are possible and if multiple
external styles either must adapt to the size limitation, in the extreme case
making all nodes have the same dimensions, or the edges will not reach the node
side unless you perform extra processing in the template.

Template has "defaults" that contains some values that the program needs and
it may also have whatever the templates need.

A "sizes" field should be a mapping from style name to a function that can
determine the size of the node. A "default" value that is used for all missing
styles must be present. The values are erb-templates.

A "template" field is an erb-string that is used for final rendering of the
output.

The template can have top-level fields that start with "base64" in which case
the content string is decoded and assigned to field with name taken from the
rest of the field name. Since "sizes" and "defaults" are mappings this in
practice works for "template" field. If you need content that is problematic
as is inside YAML in any "sizes" functions, they can refer to the decoded
result. There are no limitations on the field names.

The ERB is used with binding that contains a "$render" value. See code for what
is actually available. See classes Defaults, SizeEstimation, and Render. You
can access the template via "$render.defaults.template" when needed.

Example template produces a SVG file. Node "label" is used and if an "url"
is present, then the node text becomes a link. Note that the fields that a
template uses are arbitrary, so you can use anything you like in your own
templates. A "fill" is used as node fill color, default is "#ffffff".

## diagrammatron-template

This is a convenience script that can be used to combine files into a single
YAML-file to be used as a diagrammatron-render template. A root YAML document
can be given as a starting point. The program parameters are field name and
content file name pairs. The pairs list must appear last.

Any field that has value other than string type must be in the root document.
Any field with content in a file will be treated as if the field value is a
string and the value is base-64 encoded.

diagrammatron-render will decode base-64 encoded fields and the original string
is obtained.

Splitting the source into multiple files may be convenient during development
as you can have access to e.g. syntax highlighting for ERB or Ruby snippets.
In case of the template-field value, which is treated as an ERB-template,
it may be simpler to put pure Ruby code into another template field, and
eval it using "$render.get_binding", keeping most of the source out of the
ERB-template.

The sizes mapping has to have a match for each style used with nodes. You can
point to another style, or default, by specifying the style name. That allows
you to use the same function multiple times.

The file internal.yaml used in examples is created from root.yaml and
svg_1.1.erb by running (first extract the files using diagrammatron-get):

    diagrammatron-template --out internal.yaml --root root.yaml template svg_1.1.erb

The internal.yaml SVG 1.1 template is provided for convenience.

# Requirements

You need Ruby 2.7 or newer. Only standard library packages are used.

# Testing and installing

To run tests, run:

    rake test
    rake gem
    rake install

Alternatively, install the gem via:

    gem install diagrammatron

Directory test/port contains scripts that are used to run tests on various
operating systems. Each script is named after what uname returns on the OS
in question. Essentially these install some packages and then run all tests.

Test build logs can be found in [ismo-kärkkäinen.fi/diagrammatron](https://xn--ismo-krkkinen-gfbd.fi/diagrammatron/index.html).

# License

Copyright © 2021, 2022 Ismo Kärkkäinen

Licensed under Universal Permissive License. See LICENSE.txt.
