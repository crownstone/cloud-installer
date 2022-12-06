#!/bin/bash

# Exit when any command fails
set -e

# This script is invoked by cron, with the repo root as argument.

echo "Loading nvm"
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

cd "$1"
nvm use 16
node bin/scheduledJobs
