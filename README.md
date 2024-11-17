For standalone installation:

```shell
mkdir -p ~/.config/home-manager
git clone http://github.com/mitchcruft/nixdock ~/.config/home-manager
home-manager switch
```

To run a docker container:

```shell
./archdock.sh pull
./archdock.sh
```

## To run on WSL:
```shell
# Remove old ArchWSL:
wsl –unregister Arch

# Install new ArchWSL
https://github.com/yuk7/ArchWSL

# set up pacman
pacman-key --init
pacman-key --populate
pacman --noconfirm -Sy archlinux-keyring
pacman --noconfirm -Su

# install git
pacman --noconfirm -S git

# install zsh
pacman --noconfirm -S zsh

# Install nix
sh <(curl -L https://nixos.org/nix/install) --daemon --yes

# add users
useradd -m -G nixbld,wheel -s /bin/zsh m

# set up sudo
echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/01_wheel

# set up wsl
nano /etc/wsl.conf

'''
[network]
hostname = "batcave"

[user]
default = "m"
'''

# switch user.
# alternatively, leave and exit wsl, then clear the session:
# wsl -t Arch
su m

# should now be running as user m
# home-manager installation
mkdir ~/.config
git clone http://github.com/mitchcruft/nixdock ~/.config/home-manager
nix --extra-experimental-features "flakes nix-command" run home-manager/release-24.05 -- switch
```
