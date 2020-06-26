#!/bin/sh

packages=$(cat packages/shared.txt packages/arch.txt | sed '/^\s*$/d' | tr '\n' ' ' | sed 's:\s\+: :')
sudo pacman -S --needed $packages

