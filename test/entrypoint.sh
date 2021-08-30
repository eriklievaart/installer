#!/bin/dash
set -e


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



