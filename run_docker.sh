#!/bin/bash
cd $(dirname $0)

IMAGE=chesterfied/localdev
DISTRO=${1:-arch}

set -ex

docker build \
  . \
  -t ${IMAGE} \
  -f docker/Dockerfile.${DISTRO}

docker run \
  --rm \
  --hostname docker-${DISTRO} \
  -it ${IMAGE}
