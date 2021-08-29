#!/bin/dash

packages=$(cat packages/shared.txt packages/arch.txt | sed '/^\s*$/d' | tr '\n' ' ' | sed 's:\s\+: :')
sudo pacman -R vi
sudo pacman -S --needed $packages
[ -L '/bin/vi' ] || sudo ln -s /bin/vim /bin/vi

