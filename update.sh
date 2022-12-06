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
echo "${PREFIX}Using install dir: $INSTALL_DIR"

source "${THIS_DIR}/shared.sh"


# Update the repo: pulls, compares version, and builds.
# $1 = repo name
update() {
	if [ ! -d "$INSTALL_DIR/$1" ]; then
		echo "${PREFIX}No such directory: ${INSTALL_DIR}/${1}"
		return 1
	fi
	cd "$INSTALL_DIR/$1"

	update_tags "$1"

	prev_tag_file="${THIS_DIR}/repos/${1}/${TAG_FILE_NAME}"
	if [ -f $prev_tag_file ]; then
		prev_tag="$( cat $prev_tag_file )"
	else
		prev_tag=""
	fi
	
	latest_tag="$( git describe --tags --abbrev=0 )"
	if [ "$latest_tag" == "$prev_tag" ]; then
		echo "No new tag. Still on $prev_tag"
		return 0
	fi

	echo "New tag! Updating from $prev_tag to $latest_tag"
	
	stop "$1"
	pull_and_checkout "$1"
	build "$1"
	save_tag "$1"
	start "$1"
}


# Update all the git repos.
for repo in $GIT_REPOS ; do
	update "$repo"
done

echo "${PREFIX}Update all done!"
