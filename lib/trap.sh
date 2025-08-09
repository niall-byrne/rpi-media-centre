#!/bin/bash

# pictl trap library

set -eo pipefail

RPI_EXIT_CLEANUP_PATHS=()

_trap_cleanup() {
  local RPI_EXIT_CLEANUP_PATH

  for RPI_EXIT_CLEANUP_PATH in "${RPI_EXIT_CLEANUP_PATHS[@]}"; do
    if [[ -e "${RPI_EXIT_CLEANUP_PATH}" ]]; then
      _debug_with _cli_log_warning "TRAP: removing '${RPI_EXIT_CLEANUP_PATH}' ..."
      rm -f "${RPI_EXIT_CLEANUP_PATH}"
    fi
  done
}

_debug_with stdlib.trap.handler.err.fn.register _debug_error_handler

stdlib.trap.handler.exit.fn.register _trap_cleanup
