#!/bin/sh
set -e

install() {
	if (!(dpkg -s $1 | grep "Status: install" )) > /dev/null
	then
		update_once
		echo
		echo "Installing $1."
		apt -y -qq install $1
		check_status $?
	else
		echo "$1 is already installed"
	fi
}

check_status() {
	if [ $1 -ne 0 ]; then
		die "Installation aborted with status $1"
	fi
}

update_once() {
	if [ $UP_TO_DATE ]; then
		set +e
		apt-get update
		set -e
		UP_TO_DATE=true
	fi
}

for package in $(cat packages/shared.txt packages/debian.txt)
do
	install $package
done

if [ "$java_version" = "" ]; then
	java_version=$(apt search 'openjdk' | awk '$2 ~ /^openjdk-[0-9]{2}-jdk$/{num=substr($2, 9, 2); if(num<16){print num}}' | sort | tail -n 1)
fi
install openjdk-${java_version?}-jdk
install openjdk-${java_version?}-doc
install openjdk-${java_version?}-source
update-alternatives --set java /usr/lib/jvm/java-${java_version?}-openjdk-amd64/bin/java

