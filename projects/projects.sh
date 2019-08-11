#!/bin/sh
set -e

die() {
    echo >&2 "Error: $@"
    exit 1
}

if [ "$(id -u)" = "0" ]; then
        die "run this script as a normal user!"
fi



git_dir=~/Development/git
dependency_file="$start_dir/dependencies.txt"
buildfile=~/Development/git/ant/master.xml
repos=$(curl -s https://api.github.com/users/eriklievaart/repos | jq '.[] | .name' | tr -d '"')


if [ ! -d $git_dir ];then
	mkdir -p $git_dir
fi


for repo in $repos
do
	repo_dir="$git_dir/$repo"
	if [ -d $repo_dir ]
	then
		cd $repo_dir
		echo "$repo_dir"
		git pull
		cd - > /dev/null
	else
		git clone "https://eriklievaart@github.com/eriklievaart/$repo" $repo_dir
	fi
done

echo "building ws"
ant -f "$buildfile" -Dskip.test=true -Dskip.checkstyle=true -Dskip.preprocess=true -Dproject.name=ws master-jar-deploy -Dskip.resolve=true -Dskip.test.compile=true > /tmp/ant.log

echo "building toolkit"
ant -f "$buildfile" -Dskip.test=true -Dskip.checkstyle=true -Dproject.name=toolkit master-install >> /tmp/ant.log

echo "building antastic"
ant -f "$buildfile" -Dskip.test=true -Dskip.checkstyle=true -Dproject.name=antastic master-jar-deploy >> /tmp/ant.log

echo "generating folder structure"
for repo in $repos
do
	ant -f "$buildfile" -Dproject.name=$repo task-java-init>> /tmp/ant.log
done

echo "generating antastic metadata"
ws antastic +

echo "building remaining projects using antastic"
antastic "$(pwd)/antastic.txt"

ws generate +

