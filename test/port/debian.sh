#!/bin/sh

sudo apt-get update
sudo apt-get install -y -q ruby >/dev/null
rake test
