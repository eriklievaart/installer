#!/bin/sh
set -e


git=~/Development/git
gits @ws pull

login() {
	if [ $user ]; then
		return 0
	fi
	echo "please enter bitbucket user"
	read user
}

cd "$git"
for project in $(cat "$git/ws/main/static/workspaces.txt")
do
	dir="$git/$project"
	if [ ! -d "$dir" ]; then 
		login
		echo "$project"
		git clone https://$user@bitbucket.org/$user/$project
	fi
done


