#!/bin/bash

set -ex

function fail {
  echo "$@" >&2
  exit 1
}

function usage {
  echo "usage: $0 [distro]" >&2
  exit 1
}

[ "${USER}" ] || USER="$(whoami)"
[ "${USER}" ] || fail 'Cannot identify \${USER}'

[ "${HOME}" ] || HOME="/home/${USER}"
[ "${HOME}" ] || fail 'Cannot identify \${HOME}'

[ "${HOSTNAME}" ] || HOSTNAME="$(hostname)"
[ "${HOSTNAME}" ] || fail 'Cannot identify \${HOSTNAME}'

GITUSER="${USER}"
[ "${GITUSER}" = "m" ] && GITUSER="mikecurtis"

OS=$1
OSTYPE=
ARCH=
STANDALONE=false
DARWIN=false
HEADLESS=false
WSL=false

[ -f "/etc/wsl.conf" ] && WSL=true
[ ${WSL} ] && HEADLESS=true



if [ -z "$OS" ]; then
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
      ubuntu)
        OS="ubuntu"
        OSTYPE="linux"
        ;;
      arch|archarm)
        OS="arch"
        OSTYPE="linux"
        ;;
      nixos)
        OS="nixos"
        OSTYPE="linux"
        ;;
    esac
  fi
fi

if type uname >/dev/null 2>&1; then

  ARCH="$(uname -m)"
  if [ -z "$OS" ]; then
    case "$(uname -s)" in
      Linux)
        OS="linux"
        OSTYPE="linux"
        ;;
      Darwin)
        OS="darwin"
        OSTYPE="darwin"
        ;;
    esac
  fi

fi

case "${OS}" in
  linux|ubuntu|arch)
    STANDALONE=true
    ;;
  darwin)
    DARWIN=true
    ;;
  nixos)
    fail "NixOS unsupported!"
    ;;
  *)
    fail "OS \"${OS}\" unsupported!"
    ;;
esac

case "${OSTYPE}" in
  linux|darwin)
    ;;
  *)
    fail "OSTYPE \"${OSTYPE}\" unsupported!"
esac

case "${ARCH}" in
  x86_64)
    ;;
  arm64)
    ARCH="aarch64"
    ;;
  *)
    fail "ARCH \"${ARCH}\" unsupported!"
esac

SYSTEM="${ARCH}-${OSTYPE}"

function generate {
echo "{
  isStandalone = ${STANDALONE};
  isDarwin = ${DARWIN};
  isWsl = ${WSL};
  isHeadless = ${HEADLESS};
  system = \"${SYSTEM}\";
  stateVersion = \"24.05\";
  username = \"${USER}\";
  gitUsername = \"${GITUSER}\";
  homeDirectory = \"${HOME}\";
  hostname = \"${HOSTNAME}\";
}"
}

generate
