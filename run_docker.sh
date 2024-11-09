#!/bin/bash
cd $(dirname $0)

IMAGE=chesterfied/localdev

set -ex

docker build \
  . \
  -t ${IMAGE} \
  -f docker/Dockerfile.arch

docker run \
  --hostname arch \
  -it ${IMAGE}
