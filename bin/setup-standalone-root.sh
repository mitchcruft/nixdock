#!/bin/bash

set -ex

function fail {
  echo "$@" >&2
  exit 1
}

function usage {
  echo "usage: $0 [--wsl] -h|--hostname hostname -u|--user user --arch|--ubuntu" >&2
  exit 1
}

[[ $(id -u) -ne 0 ]] && fail "Must run as root"

ARCH=false
UBUNTU=false
WSL=false
USER="mikecurtis"
HOSTNAME="${HOSTNAME:-$(hostname)}"
DISTROS=0

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
  --arch)
    ARCH=true
    DISTROS=$((DISTROS + 1))
    shift # past argument
    ;;
  --ubuntu)
    UBUNTU=true
    DISTROS=$((DISTROS + 1))
    shift # past argument
    ;;
  --wsl)
    WSL=true
    shift # past argument
    ;;
  -u | --user)
    USER="$2"
    shift # past argument
    shift # past value
    ;;
  -h | --hostname)
    HOSTNAME="$2"
    shift # past argument
    shift # past value
    ;;
  -* | --*)
    fail "Unknown option $1"
    ;;
  *)
    POSITIONAL_ARGS+=("$1") # save positional arg
    shift                   # past argument
    ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

if ! [ "${USER}" ]; then
  fail "Must specify a --user"
fi

if ! [ "${HOSTNAME}" ]; then
  fail "Must specify a --hostname"
fi

if [ ${DISTROS} -eq 0 ]; then
  fail "No distro specied!"
fi

if [ ${DISTROS} -gt 1 ]; then
  fail "Multiple distros specied!"
fi

if ${UBUNTU}; then

  # Update system
  apt update -y
  apt upgrade -y

  # Install needed base packages
  apt install -y \
    build-essential \
    curl \
    git \
    zsh

elif ${ARCH}; then

  # Initialize pacman
  pacman-key --init
  pacman-key --populate
  pacman --noconfirm -Sy archlinux-keyring
  pacman --noconfirm -Su

  # Install needed base packages
  pacman --noconfirm -S \
    base-devel \
    curl \
    git \
    zsh

fi

# Create a wheel group if one doesn't already exist
getent group wheel || groupadd wheel

# Install nix
sh <(curl -L https://nixos.org/nix/install) --daemon --yes

# Add users
if getent passwd ${USER}; then
  usermod -aG nixbld,wheel ${USER}
  chsh -s /bin/zsh ${USER}
else
  useradd -m -G nixbld,wheel -s /bin/zsh ${USER}
fi

# Set up sudo
echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' >/etc/sudoers.d/01_wheel

if ${WSL}; then
  # Set up wsl
  echo '
  [network]
  hostname = "'${HOSTNAME}'"
  
  [user]
  default = "'${USER}'"
  ' >>/etc/wsl.conf
fi

# Install home-manager
sudo -u ${USER} sh -c '
set -ex
mkdir -p ~/.config
cd ~/.config
[ -d home-manager ] || git clone http://github.com/mitchcruft/nixdock home-manager
cd home-manager
touch .hostconfig.nix
# TODO: make --headless
make hc
PATH="/nix/var/nix/profiles/default/bin:${PATH}" NIX_CONFIG="experimental-features = nix-command flakes" nix run home-manager/release-25.05 -- switch --flake path:.
'

if ${ARCH}; then
  # Install yay
  sudo -u ${USER} sh -c '
  cd /tmp
  git clone https://aur.archlinux.org/yay-bin.git
  cd /tmp/yay-bin
  makepkg -si --noconfirm
  cd /tmp
  rm -rf yay-bin
  '
fi
