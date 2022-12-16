#!/bin/bash

# Exit when any command fails
set -e

# Get the scripts path: the path where this file is located.
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ $# -lt 2 ]; then
	echo "${PREFIX}Usage: $0 <install path> <repo-name>"
	echo "${PREFIX}Example: $0 ~/crownstone-cloud crownstone-sse-server"
	exit 1
fi

# Make sure the install dir is an absolute path, so we can always cd to it.
INSTALL_DIR="$( realpath "$1" )"
source "${THIS_DIR}/shared.sh"

# Update the repo: fetches, compares version, and builds.
# $2 = repo name

echo "${PREFIX}Updating $2"
if [ ! -d "${INSTALL_DIR}/${2}" ]; then
	echo "${PREFIX}No such directory: ${INSTALL_DIR}/${2}"
	return 1
fi
cd "${INSTALL_DIR}/${2}"

get_prev_tag "$2"
get_latest_tag "$2"
if [ "$latest_tag" == "$prev_tag" ]; then
	echo "${PREFIX}No new tag. Still on $prev_tag"
	return 0
fi

echo "${PREFIX}New tag! Updating from $prev_tag to $latest_tag"

stop "$2"
fetch_and_checkout "$2"
bash "${THIS_DIR}/repos/${2}/post-update.sh" "$prev_tag"
build "$2"
save_tag "$2"
start "$2"

echo "${PREFIX}Done updating $2"
