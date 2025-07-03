#!/bin/bash

# pictl service shim

set -eo pipefail

export RPI_EXECUTION_DIRECTORY="${PWD}"

pushd "${RPI_WORKING_DIRECTORY}" > /dev/null
./pictl "$@"
popd > /dev/null
