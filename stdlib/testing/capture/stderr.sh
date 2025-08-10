#!/bin/bash
# @file stderr.sh
# @brief A library for capturing stderr for testing.
# @description
#   This library provides functions to capture stderr from commands for testing purposes.

# stdlib testing stderr capture library

set -eo pipefail

# @description Captures the stderr of a command into the TEST_OUTPUT variable.
# @arg $@ The command to execute.
# @set TEST_OUTPUT The captured stderr.
# @exitcode ? The exit code of the executed command.
_capture.stderr() {
  local CAPTURE_RC

  exec 3>&1
  # shellcheck disable=SC2034
  TEST_OUTPUT="$("$@" 2>&1 1> /dev/null)"
  CAPTURE_RC="$?"
  exec 3>&-

  return "${CAPTURE_RC}"
}

# @description Captures the raw stderr of a command into the TEST_OUTPUT variable.
# This function is useful for capturing output that may contain special characters or newlines.
# @arg $@ The command to execute.
# @set TEST_OUTPUT The captured raw stderr.
# @exitcode ? The exit code of the executed command.
_capture.stderr_raw() {
  exec 3>&1
  # shellcheck disable=SC2034
  LC_ALL=C IFS= read -rd '' TEST_OUTPUT < <("$@" 2>&1 1> /dev/null)
  exec 3>&-

  wait "$!"
  return "$?"
}
