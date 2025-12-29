#!/root/.nix-profile/bin/bash

[ $HOME ] || (
  echo "no HOME" >&2
  exit 1
)

set -ex

STORE=$1
if [ -d ${STORE} ]; then
  echo "already exists: ${STORE}" >&2
  exit 1
fi

mkdir -p ${STORE}

ROOT="$(dirname $(dirname $(readlink $HOME/.cache/.keep)))"

for storedir in $(nix-store --query --requisites ${ROOT}); do
  cp -ar ${storedir} ${STORE}
done
