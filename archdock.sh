#!/bin/bash

cd $(dirname $0)

HOME_IMAGE=mitchcrufy/home-manager-out
OS_IMAGE=mitchcrufy/archdock

BUILD_HOME=false
PUSH_HOME=false
PULL_HOME=false
RUN_HOME=false
BUILD_OS=false
PUSH_OS=false
PULL_OS=false
RUN_OS=false

function fail {
  echo "$@" >&2
  exit 1
}

function usage {
  echo "usage: $0 [run|build|push|pull|help]" >&2
}

CMD=$1
if [ "$#" -eq 0 ]; then
  CMD=run
fi

case "$CMD" in
  run)
    RUN_OS=true
    ;;
  build)
    BUILD_HOME=true
    BUILD_OS=true
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

if ${BUILD_HOME}; then
  docker build \
    . \
    -t ${HOME_IMAGE} \
    -f docker/Dockerfile.nixhome
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
    --hostname docker-arch \
    -it ${HOME_IMAGE}
fi

if ${BUILD_OS}; then
  docker build \
    . \
    -t ${OS_IMAGE} \
    -f docker/Dockerfile.archdock
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
    --hostname docker-arch \
    -it ${OS_IMAGE}
fi
