#!/bin/bash

# Exit when any command fails
set -e

# Get the scripts path: the path where this file is located.
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ $# -lt 1 ]; then
	echo "${PREFIX}Usage: $0 <path to install to>"
	echo "${PREFIX}Example: $0 ~/crownstone-cloud"
	exit 1
fi

# Make sure the install dir is an absolute path, so we can always cd to it.
INSTALL_DIR="$( realpath "$1" )"
echo "${PREFIX}Installing to: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

source "${THIS_DIR}/shared.sh"


install_mongo() {
	echo "${PREFIX}Installing MongoDB"
	sudo apt update
	sudo apt install -y gnupg
	wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -

	# Find out what the OS codename is
	CODENAME="$( lsb_release -a | grep Codename: | awk '{print $NF}' )"

	# Use Ubuntu 20 (focal) by default.
	if [ "$CODENNAME" == "" ]; then
		CODENAME="focal"
	fi

	echo "${PREFIX}Using packages for Ubuntu $CODENAME"
	echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu ${CODENAME}/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

	sudo apt update
	sudo apt install -y mongodb-org

	# Optional: don't auto update:
	#echo "mongodb-org hold" | sudo dpkg --set-selections
	#echo "mongodb-org-server hold" | sudo dpkg --set-selections
	#echo "mongodb-org-shell hold" | sudo dpkg --set-selections
	#echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
	#echo "mongodb-org-tools hold" | sudo dpkg --set-selections

	echo "${PREFIX}Start MongoDB"
	# Ensure mongod config is picked up:
	sudo systemctl daemon-reload

	# Tell systemd to run mongod on reboot:
	sudo systemctl enable mongod

	# Start up mongod!
	sudo systemctl start mongod

	# Optionally: create an admin user (via mongo shell) and enable authorization (in mongo config file).
	echo "${PREFIX}Done installing MongoDB"
}


install_nvm() {
	echo "${PREFIX}Installing nvm"
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
	echo "${PREFIX}Done installing nvm"
}


echo "${PREFIX}The cloud server uses MongoDB to store data."
echo "${PREFIX}If it's already installed, you can skip this step."
while :; do
	echo "${PREFIX}Install MongoDB? [y/n]"
	read answer
	if [ "$answer" == "y" ]; then
		install_mongo
	elif [ "$answer" == "n" ]; then
		break
	else
		echo "${PREFIX}Type \"y\" or \"n\" and then press enter."
	fi
done


echo "${PREFIX}Node Version Manager (nvm) is used to install different versions of Node.js and Node Package Manager (npm)."
echo "${PREFIX}If it's already installed, you can skip this step."
echo "${PREFIX}Install nvm? [Y/n]"
read answer
if [ "$answer" != "n" ]; then
	install_nvm
fi


echo "${PREFIX}Installing requirements"
sudo apt install -y git


# Install all the git repos.
for repo in $GIT_REPOS ; do
	clone_and_checkout "$repo"
	build "$repo"
	install "$repo"
	save_tag "$repo"
done

echo "${PREFIX}Install all done! Installed: $GIT_REPOS"
