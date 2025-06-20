#!/bin/bash

# pictl event library

set -eo pipefail

_event_script() {
  # $1: the event script to execute

  if [[ -f ".rpi/${1}" ]]; then
    echo "-- loading .rpi/${1} file ... --"

    # Don't halt execution if the event script fails.

    if ! _filesystem_check_permissions ".rpi/${1}" "700"; then
      return 0
    fi

    ".rpi/${1}" || return 0
  fi
}
