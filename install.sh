#!/bin/bash

############
# Settings #
############

# The github user to get the git repos from.
# This can be changed to: https://github.com/Crownstone-Community
GIT_REPO_ROOT="https://github.com/crownstone"

# The names of the git repos to install.
GIT_REPOS="crownstone-cloud cloud-v2 crownstone-sse-server crownstone-webhooks crownstone-cron hub"

############

# Exit when any command fails
set -e

# Get the scripts path: the path where this file is located.
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ $# -lt 1 ]; then
	echo "Usage: $0 <path to install to>"
	echo "Example: $0 ~/crownstone-cloud"
	exit 1
fi

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


# Clones the repo, and checks out the latest tag.
# $1 = repo name
clone_and_checkout() {
	cd "$INSTALL_DIR"
	git clone "${GIT_REPO_ROOT}/${1}.git" "$1"
	cd "$1"
	latest_tag="$( git describe --tags --abbrev=0 )"
	git checkout "$latest_tag"
}

# Builds the repo
# $1 = repo name
build() {
	if [ -d "${INSTALL_DIR}/${1}" ]; then
		cd "${INSTALL_DIR}/${1}"
		bash --login "${THIS_DIR}/${1}/build.sh"
	else
		echo "No such directory: ${INSTALL_DIR}/${1}"
	fi
}

# Creates a service for the repo
# $1 = repo name
install() {
	if [ -d "${INSTALL_DIR}/${1}" ]; then
		mkdir -p ~/.config/systemd/user/
		cp "${THIS_DIR}/template.service" "~/.config/systemd/user/${1}.service"
		sed -i "s/Description=.*/Description=${1}" "~/.config/systemd/user/${1}.service"
		sed -i "s/ExecStart=.*/ExecStart=${THIS_DIR}/${1}/run.sh" "~/.config/systemd/user/${1}.service"
		systemctl --user enable ${1}
	else
		echo "No such directory: ${INSTALL_DIR}/${1}"
	fi
}


for repo in $GIT_REPOS ; do
	echo "Installing $repo"
	clone_and_checkout "$repo"
	build "$repo"
	install "$repo"
done
