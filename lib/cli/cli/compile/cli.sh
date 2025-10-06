#!/bin/bash

# pictl cli library

set -eo pipefail

_compile_cli_cli() {
  _cli_compiler_build_cli "1"
}

_compile_cli_completion() {
  _cli_compiler_build_completion
}
