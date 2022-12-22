#!/bin/bash

# Exit when any command fails
set -e

# Called after checking out the latest tag of this repo, before building.
# Assumed to be executed in the root dir of the repo.
# $1 = previous tag.
echo "Post update from tag: $1"
