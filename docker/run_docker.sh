#!/bin/bash
cd $(dirname $0)
cd ..

set -ex
docker build . -t chesterfied/localdev -f docker/Dockerfile
docker run \
  --hostname arch \
  -it \
  chesterfied/localdev
