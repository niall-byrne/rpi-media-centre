#!/bin/bash

# stdlib testing error library

set -eo pipefail

_testing.error() {
  # $@: the error messages to display

  {
    (
      while [[ -n "${1}" ]]; do
        echo "${STDLIB_COLOUR_LIGHT_RED}${1}${STDLIB_COLOUR_NC}"
        shift
      done
    )
    #:nocov:
    # bashcov doesn't report this section correctly
  } >&2
  #:nocov:
  return 127
}
