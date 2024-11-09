#!/bin/bash
cd $(dirname $0)

set -ex
docker build -t chesterfied/localdev .
docker run \
  --hostname arch \
  -it \
  chesterfied/localdev
