#!/usr/bin/dash
set -e

. ./globals.sh

die() {
    echo >&2 "Error: $@"
    exit 1
}

relink() {
	[ ${#2} -gt 10 ] || die "link to short '$2'"
	if [ ! -e "${2:?}" ]; then
		rm -f "${2:?}"
		ln -s "${1:?}" "${2:?}"
	fi
}

if [ "$(id -u)" != "0" ]; then
        die "root privileges required!"
fi

# enable firewall
ufw enable

if [ -f /usr/bin/pacman ]; then
	./arch.sh
else
	./debian.sh
fi


# only swap if absolutely necessary
swapconfig=/etc/sysctl.d/99-swappiness.conf
[ -f $swapconfig ] || echo "vm.swappiness=10" > $swapconfig


# convenience script for jumping to directories
zbashrc() {
	home=${1:?}
	bashrc=${home:?}/.bashrc
	if ! cat $bashrc | grep -q '/opt/q/q.sh'; then
		echo "" >> $bashrc
		echo ". $Z_SCRIPT" >> $bashrc
	fi
}
Z_DIR="/opt/q"
Z_SCRIPT="$Z_DIR/q.sh"
if [ -d "$Z_DIR" ]; then
	echo "shortcut(q) is already installed"
else
	echo "installing shortcut(q)"
	cp -r q /opt/q
	cd /opt/q
	chmod -w /opt/q/*
	zbashrc /root
	zbashrc "$HOME"
fi


# remove sudo requirement docker
grep -v -q '^docker:' /etc/group || groupadd docker
usermod -aG docker "$USER"


# link icewm theme
relink ${GIT_DIR?}/installer/link/mytheme /usr/share/icewm/themes/mytheme
# link custom keyboard mapping
relink ${GIT_DIR?}/installer/link/xkb/erik /usr/share/X11/xkb/symbols/erik

xdg-mime default audacious.desktop $(cat /usr/share/applications/audacious.desktop | sed -n '/[mM]ime/{s/.*[^=]=//;s/;/\n/g;p}')
xdg-mime default vlc.desktop $(cat /usr/share/applications/vlc.desktop | sed -n '/[mM]ime/{s/.*[^=]=//;s/;/\n/g;p}' | grep -v audio)

# set default sample rate to 48KHz, so that Audioengine HD3 USB connection works
pulse=/etc/pulse/daemon.conf
sed -i '/default-sample-rate/d' $pulse
sed -i '$ s/$/\ndefault-sample-rate = 48000/' $pulse

rm -f /bin/vi
sed '/^execute /d' ${GIT_DIR?}/installer/includes/link/home/.vimrc > /root/.vimrc




