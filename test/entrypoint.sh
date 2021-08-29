#!/bin/dash
set -e

# use apt cache
echo 'Acquire::http::Proxy "http://cache:3142";' > /etc/apt/apt.conf.d/01proxy

# mock setup
export java_version=17
mkdir -p /etc/pulse
touch /etc/pulse/daemon.conf
echo "#!/bin/dash" >> /bin/ufw
echo "echo 'dummy ufw' >> /bin/ufw"
chmod +x /bin/ufw

name=automated
useradd ${name:?}
export homedir=/home/${name:?}
touch "${homedir:?}/.bashrc"

cd $(find -type d -name installer)
cd includes
export USER="$name"
./as-root.sh

su ${user:?} -c ./as-root.sh
#chown ${user:?} /home/${user:?}



