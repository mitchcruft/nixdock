#!/bin/bash

cd $(dirname $0)

DISTRO=${DISTRO:-arch}

HOME_IMAGE="mitchcrufy/home-manager-out"
OS_IMAGE="mitchcrufy/${DISTRO}dock"
HOSTNAME="docker-${DISTRO}"

DOCKERFILE_HOME="docker/Dockerfile.nixhome"
BUILD_HOME=${BUILD_HOME:-false}
PUSH_HOME=${PUSH_HOME:-false}
PULL_HOME=${PULL_HOME:-false}
RUN_HOME=${RUN_HOME:-false}
DOCKERFILE_OS="docker/Dockerfile.${DISTRO}dock"
BUILD_OS=${BUILD_OS:-false}
PUSH_OS=${PUSH_OS:-false}
PULL_OS=${PULL_OS:-false}
RUN_OS=${RUN_OS:-false}

function fail {
  echo "$@" >&2
  exit 1
}

function usage {
  echo "usage: $0 [do|run|build|buildrun|push|pull|help]" >&2
}

CMD=$1
if [ "$#" -eq 0 ]; then
  CMD=run
fi

case "$CMD" in
  do)
    ;;
  run)
    RUN_OS=true
    ;;
  build)
    BUILD_HOME=true
    BUILD_OS=true
    ;;
  buildrun)
    BUILD_HOME=true
    BUILD_OS=true
    RUN_OS=true
    ;;
  push)
    BUILD_HOME=true
    PUSH_HOME=true
    BUILD_OS=true
    PUSH_OS=true
    ;;
  pull)
    PULL_HOME=true
    PULL_OS=true
    ;;
  help)
    usage
    exit 0
    ;;
  *)
    usage
    exit 1
    ;;
esac

set -ex

if ${BUILD_HOME}; then
  docker build \
    . \
    -t ${HOME_IMAGE} \
    -f 
fi

if ${PUSH_HOME}; then
  docker push ${HOME_IMAGE}
fi

if ${PULL_HOME}; then
  docker pull ${HOME_IMAGE}
fi

if ${RUN_HOME}; then
  docker run \
    --rm \
    --hostname ${HOSTNAME} \
    -it ${HOME_IMAGE}
fi

if ${BUILD_OS}; then
  docker build \
    . \
    -t ${OS_IMAGE} \
    -f ${DOCKERFILE_OS}
fi

if ${PUSH_OS}; then
  docker push ${OS_IMAGE}
fi

if ${PULL_OS}; then
  docker pull ${OS_IMAGE}
fi

if ${RUN_OS}; then
  docker run \
    --rm \
    --hostname ${HOSTNAME} \
    -it ${OS_IMAGE}
fi
