#!/bin/bash

# Exit when any command fails
set -e

if [ $# -lt 1 ]; then
	echo "Usage: $0 <path to install to>"
	echo "Example: $0 ~/crownstone-cloud"
	exit 1
fi

# This can be changed to: https://github.com/Crownstone-Community
GIT_REPO_ROOT="https://github.com/crownstone"

INSTALL_DIR="$1"
echo "Installing to: $INSTALL_DIR"

mkdir -p "$INSTALL_DIR"

install_mongo() {
	echo "Installing mongodb"
	sudo apt update
	sudo apt install gnupg
	wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -

	echo "Using Ubuntu 20 packages."
	echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

	sudo apt update
	sudo apt install -y mongodb-org

	# Optional: don't auto update:
	#echo "mongodb-org hold" | sudo dpkg --set-selections
	#echo "mongodb-org-server hold" | sudo dpkg --set-selections
	#echo "mongodb-org-shell hold" | sudo dpkg --set-selections
	#echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
	#echo "mongodb-org-tools hold" | sudo dpkg --set-selections

	echo "Start mongodb"
	# Ensure mongod config is picked up:
	sudo systemctl daemon-reload

	# Tell systemd to run mongod on reboot:
	sudo systemctl enable mongod

	# Start up mongod!
	sudo systemctl start mongod

	# Optionally: create an admin user (via mongo shell) and enable authorization (in mongo config file).
}

install_nvm() {
	echo "Installing nvm"
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
	echo "Done installing nvm"
}


echo "Install mongodb? Y/n"
read answer
if [ "$answer" != "n" ]; then
	install_mongo
fi

echo "Install nvm? Y/n"
read answer
if [ "$answer" != "n" ]; then
	install_nvm
fi



echo "Loading nvm"
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

echo "Installing Node.js and npm"
nvm install 12
nvm install 16

echo "Installing requirements"
sudo apt install git

echo "Installing cloud v1"
cd "$INSTALL_DIR"
# https://github.com/crownstone/crownstone-cloud
git clone "${GIT_REPO_ROOT}/crownstone-cloud.git"


echo "Installing cloud v2"
cd "$INSTALL_DIR"
# https://github.com/crownstone/cloud-v2
git clone "${GIT_REPO_ROOT}/cloud-v2.git"


echo "Installing SSE server"
cd "$INSTALL_DIR"
# https://github.com/crownstone/crownstone-sse-server
git cl
one "${GIT_REPO_ROOT}/crownstone-sse-server.git"

echo "Installing webhook server"
cd "$INSTALL_DIR"
# https://github.com/crownstone/crownstone-webhooks
git clone "${GIT_REPO_ROOT}/crownstone-webhooks.git"


echo "Installing hub"
cd "$INSTALL_DIR"
# https://github.com/crownstone/crownstone-cron
git clone "${GIT_REPO_ROOT}/hub.git"


echo "Installing cron jobs"
cd "$INSTALL_DIR"
# https://github.com/crownstone/hub
git clone "${GIT_REPO_ROOT}/crownstone-cron.git"


