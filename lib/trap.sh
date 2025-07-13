#!/bin/bash

# pictl trap library

set -Eeo pipefail

RPI_EXIT_CLEANUP_PATHS=()

_debug_with trap _debug_error_handler ERR
trap _trap_cleanup EXIT

_trap_cleanup() {
  local RPI_EXIT_CLEANUP_PATH

  for RPI_EXIT_CLEANUP_PATH in "${RPI_EXIT_CLEANUP_PATHS[@]}"; do
    if [[ -e "${RPI_EXIT_CLEANUP_PATH}" ]]; then
      _debug_with _cli_log_warning "TRAP: removing '${RPI_EXIT_CLEANUP_PATH}' ..."
      rm -f "${RPI_EXIT_CLEANUP_PATH}"
    fi
  done
}
