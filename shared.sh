#!/bin/bash

################
### Settings ###
################

# The github user to get the git repos from.
# This can be changed to: https://github.com/Crownstone-Community
GIT_REPO_ROOT="https://github.com/crownstone"

# The names of the git repos to install.
GIT_REPOS="crownstone-cloud cloud-v2 crownstone-sse-server crownstone-webhooks crownstone-cron hub crownstone-cloud-bridge"

# tput doesn't work when running as cron job, because $TERM is undefined.
set +e
bold=$(tput bold 2> /dev/null)
normal=$(tput sgr0 2> /dev/null)
set -e


# Print prefix
PREFIX="${bold}[Cloud installer]${normal} "

# File that stores the installed git tag.
TAG_FILE_NAME="installed.tag"

# File which existence marks an update being in progress.
LOCK_FILE_NAME="update.lock"

# MongoDB script file to insert data on install.
MONGODB_INIT_SCRIPT_FILE_NAME="mongo-init.js"
MONGODB_INIT_SCRIPT_TEMPLATE_FILE_NAME="mongo-init-template.js"

# Prefix for the service name.
SERVICE_PREFIX="cs-"

################

# Exit when any command fails
set -e

# Get the scripts path: the path where this file is located.
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "${PREFIX}Using install dir: $INSTALL_DIR"
if [ ! -d "$INSTALL_DIR" ]; then
	echo "${PREFIX}No such directory: ${INSTALL_DIR}"
	exit 1
fi


# Clones the repo, and checks out the latest tag.
# $1 = repo name
clone_and_checkout() {
	echo "${PREFIX}Cloning $1"
	cd "$INSTALL_DIR"

	if [ -e "$1" ]; then
		echo "${PREFIX}Overwriting ${INSTALL_DIR}/${1}"
		rm -rf "$1"
	fi

	git clone "${GIT_REPO_ROOT}/${1}.git" "$1"
	cd "$1"
	get_latest_tag "$1"
	git checkout "$latest_tag"
	echo "${PREFIX}Done cloning $1"
}


# Fetch the repo and checks out the latest tag.
# Assumes to be in the correct dir already.
# $1 = repo name
fetch_and_checkout() {
	echo "${PREFIX}Checking out latest tag of $1"

	git fetch

	get_latest_tag "$1"
	git checkout "$latest_tag"

	echo "${PREFIX}Done checking out latest tag of $1"
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
install_service() {
	echo "${PREFIX}Installing $1"

	if [ ! -d "$INSTALL_DIR/$1" ]; then
		echo "${PREFIX}No such directory: ${INSTALL_DIR}/${1}"
		return 1
	fi

	mkdir -p ${HOME}/.config/systemd/user/
	cp "${THIS_DIR}/template.service" "${HOME}/.config/systemd/user/${SERVICE_PREFIX}${1}.service"
	sed -i -re "s;Description=.*;Description=${1};" "${HOME}/.config/systemd/user/${SERVICE_PREFIX}${1}.service"
	sed -i -re "s;ExecStart=.*;ExecStart=${THIS_DIR}/repos/${1}/run.sh ${INSTALL_DIR}/${1};" "${HOME}/.config/systemd/user/${SERVICE_PREFIX}${1}.service"
	systemctl --user enable "${SERVICE_PREFIX}${1}"

	echo "${PREFIX}Done installing $1"
}


# Adds a cron job, first checks if it already exists.
# $1 = the timing in the form of: m h dom mon dow
# $2 = the command to execute
install_cron() {
	echo "${PREFIX}Installing cron job"
	
	set +e
	crontab -l 2>/dev/null | grep -F "$2" > /dev/null
	result=$?
	set -e

	if [ $result -eq 0 ]; then
		echo "${PREFIX}Cron job already installed, updating"
		( crontab -l 2>/dev/null | grep -vF "$2" ) | crontab -
	fi

	# With an empty crontab, this will error and write nothing to crontab.
	# So we have to ignore the error here.
	set +e
	( crontab -l 2>/dev/null; echo "$1 $2" ) | crontab -
	result=$?
	set -e

	if [ $result -ne 0 ]; then
		echo "${PREFIX}Failed to install cron job"
		return $result
	fi

	echo "${PREFIX}Done installing cron job"
}


# Start a service
# $1 = repo name
start() {
	echo "${PREFIX}Starting $1"
	systemctl --user restart "${SERVICE_PREFIX}${1}"
	echo "${PREFIX}Done starting $1"
}


# Stop a service
# $1 = repo name
stop() {
	echo "${PREFIX}Stopping $1"
	set +e
	systemctl --user stop "${SERVICE_PREFIX}${1}"
	set -e
	echo "${PREFIX}Done stopping $1"
}


# Fetches new tags from the repo.
# Assumes to be in the correct dir already.
# Result it set to variable "latest_tag"
# $1 = repo name
get_latest_tag() {
	echo "${PREFIX}Fetching $1"

	git fetch --tags
	latest_tag="$( git describe --tags $(git rev-list --tags --max-count=1) )"

	echo "${PREFIX}Done fetching $1"
}


# Get the stored tag of the current installed git tag.
# Result it set to variable "prev_tag"
# $1 = repo name (use "self" for the installer repo)
get_prev_tag() {
	prev_tag_file="${THIS_DIR}/repos/${1}/${TAG_FILE_NAME}"
	if [ "$1" == "self" ]; then
		prev_tag_file="$THIS_DIR/${TAG_FILE_NAME}"
	fi

	if [ -f $prev_tag_file ]; then
		prev_tag="$( cat $prev_tag_file )"
	else
		echo "${PREFIX}No previous installed tag found. Expected file: $prev_tag_file"
		prev_tag=""
	fi
}


# Save the latest tag of the repo to file.
# $1 = repo name (use "self" for the installer repo)
save_tag() {
	echo "${PREFIX}Saving tag of $1"

	git_dir="${INSTALL_DIR}/${1}"
	store_dir="${THIS_DIR}/repos/${1}"
	if [ "$1" == "self" ]; then
		git_dir="$THIS_DIR"
		store_dir="$THIS_DIR"
	fi

	if [ ! -d "$git_dir" ]; then
		echo "${PREFIX}No such directory: $git_dir"
		return 1
	fi

	cd "$git_dir"

	get_latest_tag "$1"
	echo "$latest_tag" > "${store_dir}/${TAG_FILE_NAME}"
	echo "${PREFIX}Done saving tag of ${1}: $latest_tag"
}
