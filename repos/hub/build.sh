#!/bin/bash

# Exit when any command fails
set -e

# Assumed to be executed in the root dir of the repo.

echo "Loading nvm"
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install 14
nvm use 14
npm install --global yarn

yarn

# No need to compile typescript to javascript, this repo comes with a dist dir.
#npm run build
