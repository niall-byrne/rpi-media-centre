#!/bin/bash

# stdlib testing stderr capture library

set -eo pipefail

_capture.stderr() {
  # $@: the commands to execute

  local CAPTURE_RC

  exec 3>&1
  # shellcheck disable=SC2034
  TEST_OUTPUT="$("$@" 2>&1 1> /dev/null)"
  CAPTURE_RC="$?"
  exec 3>&-

  return "${CAPTURE_RC}"
}

_capture.stderr_raw() {
  # $@: the commands to execute

  exec 3>&1
  # shellcheck disable=SC2034
  LC_ALL=C IFS= read -rd '' TEST_OUTPUT < <("$@" 2>&1 1> /dev/null)
  exec 3>&-

  wait "$!"
  return "$?"
}
