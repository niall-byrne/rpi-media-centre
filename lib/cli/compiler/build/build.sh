#!/bin/bash

# pictl cli build library

set -eo pipefail

# shellcheck disable=SC2034
{
  RPI_PATH_FRAGMENTS="${RPI_WORKING_DIRECTORY}/lib/cli/compiler/build/generate/target/fragments"
  RPI_PATH_COMPILED_ROOT="lib/cli/build"
  RPI_PATH_COMPILED_CLI="${RPI_PATH_COMPILED_ROOT}/cli.sh"
  RPI_PATH_COMPILED_CLI_SOURCE="${RPI_WORKING_DIRECTORY}/lib/cli/config"
  RPI_PATH_COMPILED_COMPLETION="${RPI_PATH_COMPILED_ROOT}/bash_completion.sh"
}

_cli_compiler_build_make_target_folder() {
  stdlib.security.path.make.dir "${RPI_PATH_COMPILED_ROOT}" \
    "root" \
    "root" \
    "755"
}
