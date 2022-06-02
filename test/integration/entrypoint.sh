#!/bin/dash
set -e

interactive() {
	echo ""
	echo "installer script located at:"
	echo "/installer/test/integration/entrypoint.sh"
	exec bash
}
[ "$1" = "-i" ] && interactive

# mock setup
name=automated
grep -q $name /etc/passwd || useradd ${name:?}
export USER="$name"
export homedir=/home/${name:?}
export java_version=11
git="$homedir/Development/git"


# create normal desktop linux directory structure
mkdir -p "$git"
mkdir -p "$homedir/.config"
mkdir -p /etc/pulse

touch "/etc/pulse/daemon.conf"
echo "alias ll='ls -l'" > "${homedir:?}/.bashrc"

echo "#!/bin/dash" >> /bin/ufw
echo "echo 'dummy ufw' >> /bin/ufw"
chmod +x /bin/ufw

echo 'Acquire::http::Proxy "http://apt-cacher:3142";' > /etc/apt/apt.conf.d/01proxy

cp -r /installer "$git"
chown -R $name $homedir

cd "$git/installer/includes"
find | grep root
echo "$PWD"
./root-install.sh
su ${USER:?} -c ./user-install.sh

cd ../projects
su ${USER:?} -c './projects.sh -a'
cd -

[ "$(pgrep bash)" = "" ] && interactive


