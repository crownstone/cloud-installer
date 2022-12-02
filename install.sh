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
GIT_REPOS="crownstone-cloud cloud-v2 crownstone-sse-server crownstone-webhooks crownstone-cron hub"

# Make sure the install dir is an absolute path, so we can always cd to it.
INSTALL_DIR="$( realpath "$1" )"
echo "Installing to: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

install_mongo() {
	echo "Installing mongodb"
	sudo apt update
	sudo apt install gnupg
	wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -

	# Find out what the OS codename is
	CODENAME="$( lsb_release -a | grep Codename: | awk '{print $NF}' )"

	# Use Ubuntu 20 (focal) by default.
	if [ "$CODENNAME" == "" ];
		CODENAME="focal"
	fi

	echo "Using packages for Ubuntu $CODENAME"
	echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu ${CODENNAME}/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

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


echo "Installing yarn"
npm install --global yarn


echo "Installing requirements"
sudo apt install git

# $1 = repo name
clone_and_checkout() {
	cd "$INSTALL_DIR"
	git clone "${GIT_REPO_ROOT}/${1}.git" "$1"
	cd "$1"
	latest_tag="$( git describe --tags --abbrev=0 )"
	git checkout "$latest_tag"
}

echo "Installing cloud v1"
# https://github.com/crownstone/crownstone-cloud
clone_and_checkout "crownstone-cloud"
cd "$INSTALL_DIR"
cd crownstone-cloud
yarn


echo "Installing cloud v2"
# https://github.com/crownstone/cloud-v2
cd "$INSTALL_DIR"
clone_and_checkout "cloud-v2"


echo "Installing SSE server"
cd "$INSTALL_DIR"
# https://github.com/crownstone/crownstone-sse-server
git clone "${GIT_REPO_ROOT}/crownstone-sse-server.git"

echo "Installing webhook server"
cd "$INSTALL_DIR"
# https://github.com/crownstone/crownstone-webhooks
git clone "${GIT_REPO_ROOT}/crownstone-webhooks.git"


echo "Installing cron jobs"
cd "$INSTALL_DIR"
# https://github.com/crownstone/crownstone-cron
git clone "${GIT_REPO_ROOT}/crownstone-cron.git"


echo "Installing hub"
cd "$INSTALL_DIR"
# https://github.com/crownstone/hub
git clone "${GIT_REPO_ROOT}/hub.git"


exit 0

# Make service
mkdir -p ~/.config/systemd/user/
cp crownstone.service ~/.config/systemd/user/
#chmod a-x ~/.config/systemd/user/crownstone.service
systemctl --user enable crownstone


# Latest tag in current branch, include non annotated tags as well, don't show long format.
latest_tag="$( git describe --tags --abbrev=0 )"
# if [ "$latest_tag" == "" ]; then
# 	echo "No tag found"
# 	exit 1
# fi
