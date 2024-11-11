#!/bin/bash
set -ex
root=$(realpath $(dirname $0)/darwin)
cd /tmp
# Cache credentials upfront, to avoid getting prompted at the end.
sudo true
exec darwin-rebuild --flake ${root} "$@"
