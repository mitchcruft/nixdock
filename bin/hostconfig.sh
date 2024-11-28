#!/bin/bash

set -ex

function fail {
  echo "$@" >&2
  exit 1
}

function usage {
  echo "usage: $0" >&2
  exit 1
}

[ "${USER}" ] || USER="$(whoami)"
[ "${USER}" ] || fail 'Cannot identify \${USER}'

[ "${HOME}" ] || HOME="/home/${USER}"
[ "${HOME}" ] || fail 'Cannot identify \${HOME}'

[ "${HOSTNAME}" ] || HOSTNAME="$(hostname)"
[ "${HOSTNAME}" ] || fail 'Cannot identify \${HOSTNAME}'

OS=
SYSTEM="x86_64-linux"
STANDALONE=false
DARWIN=false
WSL=false

if [ -f /etc/os-release ]; then
  . /etc/os-release
  case "$ID" in
    ubuntu)
      OS="ubuntu"
      ;;
    arch|archarm)
      OS="arch"
      ;;
    nixos)
      OS="nixos"
      ;;
  esac
fi

if [ -z "$OS" ]; then
  if type uname >/dev/null 2>&1; then
    case "$(uname)" in
      Darwin)
        OS="darwin"
        ;;
    esac
  fi
fi

case "$OS" in
  ubuntu|arch)
    STANDALONE=true
    ;;
  darwin)
    DARWIN=true
    ;;
  nixos)
    fail "NixOS unsupported!"
    ;;
  *)
    fail "OS unsupported!"
    ;;
esac

if [ -f "/etc/wsl.conf" ]; then
  WSL=true
fi

function generate {
echo "{
  isStandalone = ${STANDALONE};
  isDarwin = ${DARWIN};
  isWsl = ${WSL};
  system = \"${SYSTEM}\";
  stateVersion = \"24.05\";
  username = \"${USER}\";
  homeDirectory = \"${HOME}\";
}"
}

generate
