#!/bin/dash
set -e


# mock setup
name=automated
useradd ${name:?}

export USER="$name"
export homedir=/home/${name:?}
export java_version=17
git="$homedir/Development/git"

# create normal desktop linux directory structure
mkdir -p "$git"
mkdir -p "$homedir/.config"
mkdir -p /etc/pulse

touch "/etc/pulse/daemon.conf"
touch "${homedir:?}/.bashrc"

echo "#!/bin/dash" >> /bin/ufw
echo "echo 'dummy ufw' >> /bin/ufw"
chmod +x /bin/ufw

echo 'Acquire::http::Proxy "http://apt-cache:3142";' > /etc/apt/apt.conf.d/01proxy
cp -r /installer "$git"
chown -R $name /home/$name

cd "$git/installer/includes"
./as-root.sh
su ${USER:?} -c ./as-user.sh

echo
echo "Script completed successfully!"


