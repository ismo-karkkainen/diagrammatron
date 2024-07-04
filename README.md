# Diagrammatron

This is a small collection to programs to do the following:
- Convert a dot_json file to diagrammatron format.
- Prune nodes and attached edges from the diagram.
- Place the nodes of a graph/diagram onto a plane.
- Place edges between the nodes.
- Place separate sub-diagrams so that they do not overlap.
- Select a subset of the diagram.
- Copy edge/node fields to different name in the same edge/node.
- Turn the resulting graph into a graphics file for viewing.
- A helper script to make it easier to construct templates for conversion.

All stages are separate programs. Input file can contain information for
later stages as each stage only considers the part it needs and other
information is passed through as is.

If you have a GraphViz dot file, you can convert it using GraphViz dot tool:

    dot -Tdot_json -odiagram.json diagram.dot

Only the node names and edge end-point information is used.

# Diagram file contents

Each program has a schema of input and output file accessible using
diagrammatron-schema. The schema name is displayed in the help text.

In short initial input diagram file is a YAML file that contains:

```yaml
---
nodes:
- label: identifier
  text: Automatically split to lines, defaults to label, used in rendering.
  url: URL to use as link with text.
  style: style-name
- label: identifier2
edges:
- between: [ identifier, identifier2 ]
  style: style-name
```

The diagram file can contain styles mapping. For an example, see styles in
templates/root.yaml. Node and edge styles are separate so can have same names
but different contents.

# Programs

The programs are intended to be called in the following order:

* diagrammatron-get extracts template files from the gem.
* dot_json2diagrammatron converts from dot_json to diagrammtron format.
* diagrammatron-prune removes or retains nodes/edges from diagram.
* diagrammatron-nodes places nodes inside sub-diagrams based on distances.
* diagrammatron-edges places edges within sub-diagrams when nodes are placed.
* diagrammatron-place places sub-diagrams so that they do not overlap.
* diagrammatron-render takes the previous output and outputs a file.

In addition you may need to use:
* diagrammatron-subset
* diagrammatron-template can combine multiple files into a render template.

Unless you need to make changes, you can pipe the output of previous to the
next one, such as:

```sh
dot_json2diagrammatron -i diagram.json | diagrammatron-nodes | diagrammatron-edges | diagrammatron-place | diagrammatron-render -t internal.yaml -o diagram.svg
```

Using diagrammatron-prune can be followed e.g. by sed with various expressions
to modify node labels by getting rid of repetitive elements, if such are
present. If source is a graph produced by Terraform, you can get rid of the
local values and providers as uninteresting and clean node labels via:

```sh
diagrammatron-prune -i input.yaml ' provider' ' local.' 'meta.count-boundary' | sed -e 's/.root. //g' -e 's/ .expand.//g' > output.yaml
```

All programs retain the source fields that they do not use. Check the schemas
if you suspect field name collisions.

## diagrammatron-get

Allows obtaining the templates stored in the gem. Removes the need to clone
the source code repository.

To get the internal.yaml used in the examples, run:

```sh
diagrammatron-get internal.yaml --output internal.yaml
```

Running the program without arguments lists the available files.

It may appear inconvenient to extract files before they can be used but at
this point the assumption is that you should modify the template that produces
the SVG output. Since multiple commands are needed to produce the end result,
if is convenient to put all into a script and have the internal template, when
used, pulled out first and removed at the end.

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
fields and disjoint sub-graph identifier to "sid". A few simple algorithms
are available. Coordinates indicate the ordering of nodes and not where they
should actually be located. Disjoint sub-diagrams will be placed on top of
each other.

For algorithm "vertical", field "xo" is retained. For algorithm "horizontal",
field "yo" is retained. Both should have integer value.

## diagrammatron-edges

Places edges between nodes within each connected sub-diagram by removing
candidates that have most crossings. Each edges has only horizontal and
vertical segments with 90-degree angles.

Currently uses simple sorting within groups to determine the order of edge
segments with regard to each other when they are in same gap between nodes.

Fields "path" and "sid" are added to each edge.

## diagrammatron-place

Places disjoint sub-diagrams in relation to each other so that they do not
overlap. The bounding rectangle side length sum is minimized. The width to
height ratio of the nodes can be taken into account using --ratio parameter.
All nodes are considered point-like at this stage. Not using ratio will
probably result in elongated output from diagrammatron-render.

## diagrammatron-render

Takes a template and uses it to produce a file. The template file is in YAML
format. The internal.yaml provided in this repository produces a SVG 1.1 file.

If a node has field named "text", it replaces "label" and is split to multiple
strings on newline character.

Nodes are expected to have a field named "style" that defaults to "default"
if missing. The style is used to find a function that assigns width and height
to the node before final sizes are assigned. The algorithm at this point relies
on each column having nodes of equal width and each row having nodes of equal
height. Consequently only rectangular nodes are possible, and multiple
external styles either must adapt to the size limitation, in the extreme case
making all nodes have the same dimensions, or the edges will not reach the node
side unless you perform extra processing in the template.

Nodes and edges can have a depth-field that is used to sort nodes in descending
order of depth. Values with largest depth are first. Nodes and edges are also
combined into an array "all" with "kind" as "node" or "edge", depth, and "item"
as the node or edge object. The depth is probably most useful in style when you
want to render different colored edges behind or above others. Nodes do not
overlap but the ordering with regard to edges may show if you render for
example arrow-heads at the end of edges.

Each node, edge, and the diagram itself will have all fields in style "default"
and any styles that are listed in the node or edge copied to each item. The
template code can expect to find all values present in the node or edge.

A "template" field is an ERB string that is used for final rendering of the
output.

The template file can have top-level fields that start with "base64" in which
case the content string is decoded and assigned to field with "base64" dropped.
If you need content that is problematic as is inside YAML in "size_estimate"
functions, they can refer to the decoded result.

The ERB is used with binding that contains a "$render" value. See code for what
is actually available. See classes SizeEstimation and Render. You can access
the template via "$render.template" and the source file via "$render.doc".

Included template produces a SVG file. Node "text" is used and if an "url"
is present, then the node text becomes a link. Note that the fields that a
template uses are arbitrary, so you can use anything you like in your own
templates. Having the default styles contain all needed values with sensible
values helps keep any default values out of the ERB template itself.

## diagrammatron-subset

This is intended to select a subset of the input diagram. You can define rules
and expressions for use in the selection, with regular expressions used to
match given field contents.

The program only removes nodes and edges from the diagram without changing
contents otherwise. It can be run at any stage. For example, you can select a
subset before placing nodes and edges to obtain a smaller diagram, or select
the subset afterwards to keep everything in the place it was in the full
diagram.

## diagrammatron-copy

This is intended for case where you use diagrammatron-subset and you want to
apply different styles, for example, in the ub-iagram that gets generated. You
can add the sub-diagram styles under a different field name, and use this to
copy the field to the style field that the rendering template expects to be
present.

The original fields remain. Source and destination field names are passed as
pairs on the command-line. First all source values are gathered, and then
written to destination fields, so you can move original field value to a new
field or swap field values. Copies are not chained, so if you want to copy a
source field to multiple destination fields, specify the same source multiple
times with different destination each time. Missing source fields are ignored.

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
In case of the template-field value, which is treated as an ERB template,
it may be simpler to put pure Ruby code into another template field, and
eval it using "$render.exposed_binding", keeping most of the source out of the
ERB template.

The file internal.yaml used in examples is created from root.yaml and
svg_1.1.erb by running (first extract the files using diagrammatron-get):

```sh
diagrammatron-template --out internal.yaml --root root.yaml template svg_1.1.erb
```

The internal.yaml SVG 1.1 template is provided mainly for convenience.

# Requirements

You need Ruby 3.0 or newer. Gemfile contains development-time requirements.
Originally developed for Ruby 2.7 so probably runs on it but not tested for
it anymore.

# Testing and installing

To run tests, run:

```sh
rake test
rake gem
rake install
```

Alternatively, install the gem from RubyGems.org via:

```sh
gem install diagrammatron
```

Test build logs can be found in [ismo-kärkkäinen.fi/diagrammatron](https://xn--ismo-krkkinen-gfbd.fi/diagrammatron/index.html).

# License

Copyright © 2021-2024 Ismo Kärkkäinen

Licensed under Universal Permissive License. See LICENSE.txt.
