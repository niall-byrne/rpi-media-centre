#!/bin/bash

# pictl event library

set -eo pipefail

_event_script() {
  # $1: the event script to execute

  if stdlib.io.path.query.is_file "${RPI_EVENTS_PATH}/${1}"; then
    _cli_log_notice "-- loading ${RPI_EVENTS_PATH}/${1} file ... --"

    # Don't halt execution if the event script fails.

    if ! stdlib.security.path.assert.is_secure "${RPI_EVENTS_PATH}" "root" "root" "700" ||
      ! stdlib.security.path.assert.is_secure "${RPI_EVENTS_PATH}/${1}" "root" "root" "700"; then
      return 0
    fi

    "${RPI_EVENTS_PATH}/${1}" || return 0
  fi
}
