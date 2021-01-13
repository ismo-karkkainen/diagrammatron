# Diagrammatron

This is a small collection to programs to do three things:
- Place the nodes of a graph/diagram onto a plane.
- Place edges between the nodes.
- Turn the resulting graph into a graphics file for viewing.

All stages are separate programs. Input file can contain information for
later stages as each stage only considers the part it needs and other
information is passed through as is.

# Requirements

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
