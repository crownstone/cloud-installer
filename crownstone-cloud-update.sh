#!/bin/bash

# Exit when any command fails
set -e

# Get the scripts path: the path where this file is located.
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ $# -lt 1 ]; then
	echo "${PREFIX}Usage: $0 <install path>"
	echo "${PREFIX}Example: $0 ~/crownstone-cloud"
	exit 1
fi

# Make sure the install dir is an absolute path, so we can always cd to it.
INSTALL_DIR="$( realpath "$1" )"
source "${THIS_DIR}/shared.sh"

# Check lock file
lock_file="${THIS_DIR}/${LOCK_FILE_NAME}"
if [ -e "$lock_file" ]; then
	echo "${PREFIX}Update already in progess: $lock_file exists."
	exit 1
fi

touch "$lock_file"

# Update this repo first.
echo "${PREFIX}Updating self"
cd "$THIS_DIR"
get_latest_tag "self"
get_prev_tag "self"

if [ "$latest_tag" == "$prev_tag" ]; then
	echo "${PREFIX}No new tag. Still on $prev_tag"
else
	echo "${PREFIX}New tag! Updating self from $prev_tag to $latest_tag"

	fetch_and_checkout "self"

	bash "${THIS_DIR}/post-self-update.sh" "$prev_tag" "$INSTALL_DIR"

	save_tag "self"

	echo "${PREFIX}Updated self to $latest_tag"

	# Exit, so that the repos will be updated with new update script.
	exit 0
fi


# Update the repo: fetches, compares version, and builds.
# $1 = repo name
update() {
	echo "${PREFIX}Updating $1"
	if [ ! -d "${INSTALL_DIR}/${1}" ]; then
		echo "${PREFIX}No such directory: ${INSTALL_DIR}/${1}"
		return 1
	fi
	cd "${INSTALL_DIR}/${1}"

	get_prev_tag "$1"
	get_latest_tag "$1"
	if [ "$latest_tag" == "$prev_tag" ]; then
		echo "${PREFIX}No new tag. Still on $prev_tag"
		return 0
	fi

	echo "${PREFIX}New tag! Updating from $prev_tag to $latest_tag"
	
	stop "$1"
	fetch_and_checkout "$1"
	build "$1"
	save_tag "$1"
	start "$1"
}


# Update all the git repos.
for repo in $GIT_REPOS ; do
	update "$repo"
done

rm "$lock_file"
echo "${PREFIX}Update all done!"
