#!/bin/sh

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

update_once() {
	if [ $UP_TO_DATE ]; then
		set +e
		sudo apt-get update
		set -e
		UP_TO_DATE=true
	fi
}

for package in $(cat config/packages.txt)
do
	install $package
done

java_version=8
install openjdk-${java_version?}-jdk
install openjdk-${java_version?}-doc
sudo update-alternatives --set java /usr/lib/jvm/java-${java_version?}-openjdk-amd64/jre/bin/java

