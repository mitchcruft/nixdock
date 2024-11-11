#!/root/.nix-profile/bin/bash

set -ex

STORE=$1
if [ -d ${STORE} ]; then
  echo "already exists: ${STORE}" >&2
  exit 1
fi

mkdir -p ${STORE}

ROOT="$(dirname $(dirname $(readlink /home/m/.cache/.keep)))"

for storedir in $(nix-store --query --requisites ${ROOT}); do
  cp -ar ${storedir} ${STORE}
done
