#!/bin/bash --login

# Exit when any command fails
set -e

# Assumed to be executed in the root dir of the repo.
nvm use 12

yarn
