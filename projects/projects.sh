#!/bin/dash
set -e

. ../includes/globals.sh

YELLOW='\033[1;33m'
RED='\033[1;31m'
PLAIN='\033[0m'

die() {
    echo >&2 "Error: $@"
    exit 1
}

if [ "$(id -u)" = "0" ]; then
        die "run this script as a normal user!"
fi



buildfile=${GIT_DIR?}/ant/master.xml
repos=$(curl -s https://api.github.com/users/eriklievaart/repos | jq '.[] | .name' | tr -d '"')




usage() {
	echo "usage: $(basename $0) [-gia]" 1>&2
	echo "	-g	git: clone or pull git repos"
	echo "	-i	install: build binaries and deploy them"
	echo "	-a	all: run all tasks"
        exit 1
}

sources() {
	if [ ! -d ${GIT_DIR?} ];then
		mkdir -p ${GIT_DIR?}
	fi

	for repo in $repos
	do
		repo_dir="${GIT_DIR?}/$repo"
		if [ -d $repo_dir ]
		then
			cd $repo_dir
			echo "$repo_dir"

			if git diff-index --quiet HEAD --; then
				git pull --rebase
			else
				echo "${YELLOW}outgoing changes! not pulling '$repo_dir'${PLAIN}"
			fi

			cd - > /dev/null
		else
			git clone "https://eriklievaart@github.com/eriklievaart/$repo" $repo_dir
		fi
	done
}

install() {
	echo "building ws"
	repo=~/bin/repo
	ant -f "$buildfile" -Dskip.test=true -Dskip.checkstyle=true -Dskip.preprocess=true -Dproject.name=ws jar-deploy -Dskip.resolve=true -Dskip.test.compile=true > /tmp/ant.log
	ant -f "$buildfile" -Dproject.name=ws -Dproject.main=com.eriklievaart.ws.boot.Rp -Ddeploy.local.sh.file=$repo task-deploy-sh

	echo "building toolkit"
	ant -f "$buildfile" -Dskip.test=true -Dskip.checkstyle=true -Dproject.name=toolkit install >> /tmp/ant.log

	echo "building antastic"
	ant -f "$buildfile" -Dskip.test=true -Dskip.checkstyle=true -Dproject.name=antastic jar-deploy >> /tmp/ant.log

	echo "generating folder structure"
	for repo in $repos
	do
		ant -f "$buildfile" -Dproject.name=$repo task-java-init >> /tmp/ant.log
	done

	echo "generating antastic metadata"
	~/bin/ws antastic +

	echo "building remaining projects using antastic"
	~/bin/antastic "$(pwd)/antastic.txt"

	~/bin/ws generate +
	sh docgen.sh
}


echo ""
case "$1" in
	-i) install ;;
	-g) sources ;;
	-a) sources; install ;;
	-s) echo "skipping projects" ;;
	*) usage;;
esac


