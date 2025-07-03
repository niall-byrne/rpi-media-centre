#!/bin/bash

# pictl event library

set -eo pipefail

_event_script() {
  # $1: the event script to source

  if [[ -f ".rpi/${1}" ]]; then
    echo "-- loading .rpi/${1} file ... --"
    _filesystem_check_permissions ".rpi/${1}" "700"

    ".rpi/${1}"
  fi
}
