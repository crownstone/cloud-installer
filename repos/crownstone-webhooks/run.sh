#!/bin/bash

# Exit when any command fails
set -e

# This script is started as service, with the repo root as argument.

echo "Loading nvm"
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Get the path where this file is located.
this_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load the environment variables.
source "${this_path}/environment-variables.sh"

cd "$1"
nvm use 16
node ./execute.js &
