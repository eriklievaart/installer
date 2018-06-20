#!/bin/sh

set -e


git_dir=~/Development/git
dependency_file="$start_dir/dependencies.txt"
buildfile=~/Development/git/ant/master.xml


if [ ! -d $git_dir ];then
	mkdir $git_dir
fi

for repo in $(sed '/@EOF@/,$ d; s/=>.*//' repos.txt)
do
	repo_dir="$git_dir/$repo"
	if [ -d $repo_dir ]
	then
		echo "repo already exists: $repo_dir"
	else
		git clone "https://bitbucket.org/Lievaart/$repo" $repo_dir
	fi
done

echo "building ws"
ant -f "$buildfile" -Dskip.test=true -Dskip.checkstyle=true -Dproject.name=ws master-deploy-jar -Dskip.resolve=true > /tmp/ant.log

echo "building toolkit"
ant -f "$buildfile" -Dskip.test=true -Dskip.checkstyle=true -Dproject.name=toolkit master-install >> /tmp/ant.log

echo "building antastic"
ant -f "$buildfile" -Dskip.test=true -Dskip.checkstyle=true -Dproject.name=antastic master-jar-deploy >> /tmp/ant.log

echo "generating antastic metadata"
ws generate +

echo "building remaining projects using antastic"
antastic "$(pwd)/antastic.txt"


