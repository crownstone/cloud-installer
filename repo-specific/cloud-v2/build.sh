#!/bin/bash --login

# Exit when any command fails
set -e

# Assumed to be executed in the root dir of the repo.

echo "Loading nvm"
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install 16
nvm use 16
npm install --global yarn

git remote add heroku https://git.heroku.com/crownstone-cloud-v2.git

yarn

# Compile typescript to javascript
npm build
