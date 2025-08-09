#!/bin/bash

# pictl service shim

set -eo pipefail

export RPI_EXECUTION_DIRECTORY="${PWD}"

pushd "${RPI_REPOSITORY_LOCATION}/source" > /dev/null
./pictl "$@"
popd > /dev/null
