#!/bin/sh
set -e                    # fail on errors
sh -n as-root.sh          # check this file for syntax errors before executing it

. ./globals.sh

die() {
    echo >&2 "Error: $@"
    exit 1
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

if [ "$(id -u)" != "0" ]; then
        die "root privileges required!"
fi

# enable firewall
sudo ufw enable 
echo ""

# allow users to invoke shutdown
sudo chmod +s /sbin/shutdown

for package in $(cat config/packages.txt)
do
	install $package
done

java_version=8
install openjdk-${java_version?}-jdk
install openjdk-${java_version?}-doc
sudo update-alternatives --set java /usr/lib/jvm/java-${java_version?}-openjdk-amd64/jre/bin/java


# convenience script for jumping to directories
Z_PARENT="/opt"
Z_DIR="$Z_PARENT/z"
Z_SCRIPT="$Z_DIR/z.sh"

if [ -d "$Z_DIR" ]; then
	echo "shortcut(z) is already installed"
else
	echo "installing shortcut(z)"
	cd "$Z_PARENT"
	git clone https://github.com/rupa/z
	chmod a+x "$Z_SCRIPT"

	if ! cat ~/.bashrc | grep -q '/z/z.sh'; then
		echo "" >> .bashrc
		echo "_Z_DATA=~/.cache/z" >> .bashrc
		echo ". $Z_SCRIPT" >> ~/.bashrc
	fi
fi

# install icewm theme
themedir=/usr/share/icewm/themes/mytheme
if [ ! -e ${themedir?} ]; then
	sudo ln -s ${GIT_DIR?}/installer/link/mytheme "${themedir?}"
fi

keyboard=/usr/share/X11/xkb/symbols/erik
if [ ! -e ${keyboard?} ]; then
	sudo ln -s ${GIT_DIR?}/installer/link/xkb/erik "${keyboard?}"
fi

# open media with vlc by default
defaults=/usr/share/applications/defaults.list
defaults_bak=$defaults.bak
if [ -f "${defaults?}" -a ! -f "${defaults_bak?}" ]; then
    echo "setting vlc as default media player in $defaults"
    sed -i -r '/xplayer.desktop|Totem.desktop/s:=(.*):=vlc.desktop;\1:p' "$defaults"
    cp -n "${defaults?}" "${defaults_bak?}"

elif [ -f "${defaults_bak}" ]; then
    echo "$defaults already modified"
else
    echo "cannot configure vlc, ${defaults?} not found."
fi

