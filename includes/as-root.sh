#!/bin/sh
set -e                    # fail on errors
sh -n as-root.sh          # check this file for syntax errors before executing it

. ../globals.sh

die() {
    echo >&2 "Error: $@"
    exit 1
}

relink() {
	[ ${#2} -gt 10 ] || die "link to short '$2'"
	if [ ! -e "${2:?}" ]; then
		rm -f "${2:?}"
		sudo ln -s "${1:?}" "${2:?}"
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
	if ! cat $bashrc | grep -q '/z/z.sh'; then
		echo "" >> $bashrc
		echo "_Z_DATA=${home:?}/.cache/z" >> $bashrc
		echo ". $Z_SCRIPT" >> $bashrc
	fi
}
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
	zbashrc /root
	zbashrc "$HOME"
fi


# link icewm theme
relink ${GIT_DIR?}/installer/link/mytheme /usr/share/icewm/themes/mytheme
# link custom keyboard mapping
relink ${GIT_DIR?}/installer/link/xkb/erik /usr/share/X11/xkb/symbols/erik


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

# set default sample rate to 48KHz, so that Audioengine HD3 USB connection works
pulse=/etc/pulse/daemon.conf
sed -i '/default-sample-rate/d' $pulse
sed -i '$ s/$/\ndefault-sample-rate = 48000/' $pulse

