#!/bin/bash

# Exit when any command fails
set -e

# Get the scripts path: the path where this file is located.
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Called after updating this repo.
# $1 = previous tag.
# $2 = install dir.

# Make sure the install dir is an absolute path, so we can always cd to it.
INSTALL_DIR="$( realpath "$2" )"

source "${THIS_DIR}/shared.sh"

echo "${PREFIX}Post self update from tag: $1"
