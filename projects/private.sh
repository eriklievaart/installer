#!/bin/sh
set -e

. ../includes/globals.sh

gits @ws pull

login() {
	if [ $user ]; then
		return 0
	fi
	echo "please enter bitbucket user"
	read user
}

cd "${GIT_DIR?}"
for project in $(cat "${GIT_DIR?}/ws/main/static/workspaces.txt")
do
	if [ ! -d "${GIT_DIR?}/$project" ]; then
		login
		echo "$project"
		git clone https://$user@bitbucket.org/$user/$project
	fi
done


