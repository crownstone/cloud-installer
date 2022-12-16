#!/bin/bash

# Exit when any command fails
set -e

# This script is started as service, with the repo root as argument.

# Get the path where this file is located.
this_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load the environment variables.
source "${this_path}/environment-variables.sh"

cd "$1"
./dummy.sh &
