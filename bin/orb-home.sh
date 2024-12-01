#!/bin/bash

cd $(dirname $0)

DISTRO=$1
NAME="orb-${DISTRO}"
USER="${USER:-$(whoami)}"

function fail {
  echo "$@" >&2
  exit 1
}

function usage {
  echo "usage: $0 distro" >&2
  exit 1
}

case ${DISTRO} in
  arch|ubuntu)
    ;;
  *)
    fail "Unsupported DISTRO: \"${DISTRO}\""
    ;;
esac

set -ex

orbctl create ${DISTRO} ${NAME}
orbctl -m ${NAME} push setup-standalone-root.sh /tmp/setup-standalone-root.sh
orbctl -m ${NAME} -u root run bash /tmp/setup-standalone-root.sh --user ${USER} --${DISTRO}
orbctl -m ${NAME} -u ${USER} shell
