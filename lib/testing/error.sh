#!/bin/bash

# pictl testing error library

set -eo pipefail

_test_error() {
  # $@: the error messages to display

  {
    (
      _io_colours_load "1"

      while [[ -n "${1}" ]]; do
        echo "${COLOUR_LIGHT_RED}${1}${COLOUR_NC}"
        shift
      done
    )
  } >&2
  return 127
}
