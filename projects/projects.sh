#!/bin/sh

set -e


git_dir=~/Development/git
dependency_file="$start_dir/dependencies.txt"
buildfile=~/Development/git/ant/master.xml


if [ ! -d $git_dir ];then
	mkdir -p $git_dir
fi


for repo in $(curl -s https://api.github.com/users/eriklievaart/repos | jq '.[] | .name' | tr -d '"')
do
	repo_dir="$git_dir/$repo"
	if [ -d $repo_dir ]
	then
		cd $repo_dir
		git pull
		cd -
	else
		git clone "https://github.com/eriklievaart/$repo" $repo_dir
	fi
done

echo "building ws"
ant -f "$buildfile" -Dskip.test=true -Dskip.checkstyle=true -Dskip.preprocess=true -Dproject.name=ws master-jar-deploy -Dskip.resolve=true > /tmp/ant.log

echo "building toolkit"
ant -f "$buildfile" -Dskip.test=true -Dskip.checkstyle=true -Dproject.name=toolkit master-install >> /tmp/ant.log

echo "building antastic"
ant -f "$buildfile" -Dskip.test=true -Dskip.checkstyle=true -Dproject.name=antastic master-jar-deploy >> /tmp/ant.log

echo "generating antastic metadata"
ws antastic +

echo "building remaining projects using antastic"
antastic "$(pwd)/antastic.txt"

ws generate +

