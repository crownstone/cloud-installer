#!/bin/bash

################
### Settings ###
################

# The github user to get the git repos from.
# This can be changed to: https://github.com/Crownstone-Community
GIT_REPO_ROOT="https://github.com/crownstone"

# The names of the git repos to install.
GIT_REPOS="crownstone-cloud cloud-v2 crownstone-sse-server crownstone-webhooks crownstone-cron hub"

bold=$(tput bold)
normal=$(tput sgr0)

# Print prefix
PREFIX="${bold}[Cloud installer]${normal} "

# File that stores the latest built git tag.
TAG_FILE_NAME="latest.tag"

# File that stores the install parameters.
INSTALL_FILE_NAME="install.txt"

################

# Exit when any command fails
set -e

# Get the scripts path: the path where this file is located.
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "INSTALL_DIR=${INSTALL_DIR}"
if [ -d "$INSTALL_DIR" ]; then
	echo "yes"
else
	echo "no"
	exit 1
fi


# Clones the repo, and checks out the latest tag.
# $1 = repo name
clone_and_checkout() {
	echo "${PREFIX}Cloning $1"
	cd "$INSTALL_DIR"

	if [ -e "$1" ]; then
		echo "${PREFIX}${INSTALL_DIR}/${1} already exists, overwrite? [y/N]"
		read answer
		if [ "$answer" != "y" ]; then
			echo "${PREFIX}Canceled installation"
			return 1
		fi
		rm -rf "${1}"
	fi

	git clone "${GIT_REPO_ROOT}/${1}.git" "$1"
	cd "$1"
	latest_tag="$( git describe --tags --abbrev=0 )"
	git checkout "$latest_tag"
	echo "${PREFIX}Done cloning $1"
}


# Pulls the repo, and checks out the latest tag.
# $1 = repo name
pull_and_checkout() {
	echo "${PREFIX}Pulling $1"

	cd "$INSTALL_DIR"
	if [ ! -d "$1" ]; then
		echo "${PREFIX}No such directory: ${INSTALL_DIR}/${1}"
		return 0
	fi

	cd "$1"
	git pull
	latest_tag="$( git describe --tags --abbrev=0 )"
	git checkout "$latest_tag"

	echo "${PREFIX}Done pulling $1"
}


# Builds the repo
# $1 = repo name
build() {
	echo "${PREFIX}Building $1"
	if [ -d "${INSTALL_DIR}/${1}" ]; then
		cd "${INSTALL_DIR}/${1}"
		bash "${THIS_DIR}/repos/${1}/build.sh"
	else
		echo "${PREFIX}No such directory: ${INSTALL_DIR}/${1}"
		return 1
	fi
	echo "${PREFIX}Done building $1"
}


# Creates a service for the repo
# $1 = repo name
install() {
	echo "${PREFIX}Installing $1"
	if [ -d "${INSTALL_DIR}/${1}" ]; then
		mkdir -p ${HOME}/.config/systemd/user/
		cp "${THIS_DIR}/template.service" "${HOME}/.config/systemd/user/${1}.service"
		sed -i -re "s;Description=.*;Description=${1};" "${HOME}/.config/systemd/user/${1}.service"
		sed -i -re "s;ExecStart=.*;ExecStart=${THIS_DIR}/repos/${1}/run.sh ${INSTALL_DIR}/${1};" "${HOME}/.config/systemd/user/${1}.service"
		systemctl --user enable ${1}
	else
		echo "${PREFIX}No such directory: ${INSTALL_DIR}/${1}"
	fi
	echo "${PREFIX}Done installing $1"
}


# Save the latest tag of the repo to file.
# $1 = repo name
save_tag() {
	echo "${PREFIX}Saving tag of $1"

	if [ ! -d "$INSTALL_DIR/$1" ]; then
		return 1
	fi

	cd "$INSTALL_DIR/$1"
	latest_tag="$( git describe --tags --abbrev=0 )"
	echo "$latest_tag" > "${THIS_DIR}/repos/${1}/${TAG_FILE_NAME}"
	echo "${PREFIX}Done saving tag of ${1}: $latest_tag"
}
