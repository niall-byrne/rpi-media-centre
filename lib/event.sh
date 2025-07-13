#!/bin/bash

# pictl event library

set -eo pipefail

_event_script() {
  # $1: the event script to execute

  if [[ -f "/etc/rpi/events/${1}" ]]; then
    echo "-- loading /etc/rpi/events/${1} file ... --"

    # Don't halt execution if the event script fails.

    if ! _security_path_check "/etc/rpi/events" "root" "root" "700" ||
      ! _security_path_check "/etc/rpi/events/${1}" "root" "root" "700"; then
      return 0
    fi

    "/etc/rpi/events/${1}" || return 0
  fi
}
