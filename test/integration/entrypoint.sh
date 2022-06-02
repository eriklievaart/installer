#!/bin/dash
set -e

if [ "$1" = "-i" ]; then
	echo
	echo '<enter> to run tests, type "bash" to start bash'
	read input
fi
if [ "$input" != "" ]; then
	echo ""
	echo "installer script located at:"
	echo "/installer/test/integration/entrypoint.sh"
	echo ""
	exec "$input"
fi

# mock setup
name=automated
useradd ${name:?}

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

echo 'Acquire::http::Proxy "http://apt-cache:3142";' > /etc/apt/apt.conf.d/01proxy
cp -r /installer "$git"
chown -R $name /home/$name

cd "$git/installer/includes"
./root-install.sh
su ${USER:?} -c ./user-install.sh

cd ../projects
su ${USER:?} -c './projects.sh -a'



