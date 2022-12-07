#!/bin/bash

# Exit when any command fails
set -e

# Get the scripts path: the path where this file is located.
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "${THIS_DIR}/shared.sh"

# Called after updating this repo.
# $1 = previous tag.

echo "${PREFIX}Post self update from tag: $1"
