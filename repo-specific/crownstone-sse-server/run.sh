#!/bin/bash --login

# Exit when any command fails
set -e

# This script is started as service, with the repo root as argument.
cd "$1"
nvm use 16
npm start
