#!/bin/bash

# pictl service shim

set -eo pipefail

pushd "${RPI_WORKING_DIRECTORY}" > /dev/null
./pictl "$@"
popd > /dev/null
