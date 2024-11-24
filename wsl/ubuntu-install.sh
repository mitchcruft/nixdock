#!/bin/bash

set -ex

sudo apt update -y
sudo apt upgrade -y
sudo apt install -y git zsh

# Install nix
sh <(curl -L https://nixos.org/nix/install) --daemon --yes

# Add users
useradd -m -G nixbld,wheel -s /bin/zsh m

# Set up sudo
echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/01_wheel

# Set up wsl
echo '
[network]
hostname = "batcave"

[user]
default = "m"
' >> /etc/wsl.conf

# Install home-manager
sudo -u m sh -c '
set -ex
mkdir ~/.config
git clone http://github.com/mitchcruft/nixdock /home/m/.config/home-manager
PATH="/nix/var/nix/profiles/default/bin:${PATH}" nix --extra-experimental-features "flakes nix-command" run home-manager/release-24.05 -- switch
'
