#!/bin/bash
cd $(dirname $0)

HOME_IMAGE=chesterfied/localhome
IMAGE=chesterfied/localdev

set -ex

docker build \
  . \
  -t ${HOME_IMAGE} \
  -f docker/Dockerfile.nixhome

docker build \
  . \
  -t ${IMAGE} \
  -f docker/Dockerfile.archhome

docker run \
  --rm \
  --hostname docker-arch \
  -it ${IMAGE}
