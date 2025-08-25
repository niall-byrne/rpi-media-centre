#!/bin/bash

# stdlib testing stdout capture library

builtin set -eo pipefail

_capture.stdout() {
  # $@: the commands to execute

  # shellcheck disable=SC2034
  TEST_OUTPUT="$("$@" 2> /dev/null)"
}

_capture.stdout_raw() {
  # $@: the commands to execute

  # shellcheck disable=SC2034
  LC_ALL=C IFS= builtin read -rd '' TEST_OUTPUT < <("$@" 2> /dev/null)

  wait "$!"
  return "$?"
}
