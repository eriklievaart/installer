#!/bin/sh
set -e

install() {
	if (!(dpkg -s $1 | grep "Status: install" )) > /dev/null
	then
		update_once
		echo "Installing $1."
		sudo apt-get -y install $1
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
		sudo apt-get update
		set -e
		UP_TO_DATE=true
	fi
}

for package in $(cat packages/shared.txt packages/debian.txt)
do
	install $package
done

java_version=11
install openjdk-${java_version?}-jdk
install openjdk-${java_version?}-doc
sudo update-alternatives --set java /usr/lib/jvm/java-${java_version?}-openjdk-amd64/bin/java

