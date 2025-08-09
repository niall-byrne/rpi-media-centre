#!/bin/bash

# pictl event library

set -eo pipefail

_event_script() {
  # $1: the event script to execute

  if [[ -f "/etc/rpi/events/${1}" ]]; then
    _cli_log_notice "-- loading /etc/rpi/events/${1} file ... --"

    # Don't halt execution if the event script fails.

    if ! stdlib.security.path.query.is_secure "/etc/rpi/events" "root" "root" "700" ||
      ! stdlib.security.path.query.is_secure "/etc/rpi/events/${1}" "root" "root" "700"; then
      return 0
    fi

    "/etc/rpi/events/${1}" || return 0
  fi
}
