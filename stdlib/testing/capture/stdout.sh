#!/bin/bash
# @file stdout.sh
# @brief A library for capturing stdout for testing.
# @description
#   This library provides functions to capture stdout from commands for testing purposes.

# stdlib testing stdout capture library

set -eo pipefail

# @description Captures the stdout of a command into the TEST_OUTPUT variable.
# @arg $@ The command to execute.
# @set TEST_OUTPUT The captured stdout.
_capture.stdout() {
  # shellcheck disable=SC2034
  TEST_OUTPUT="$("$@" 2> /dev/null)"
}

# @description Captures the raw stdout of a command into the TEST_OUTPUT variable.
# This function is useful for capturing output that may contain special characters or newlines.
# @arg $@ The command to execute.
# @set TEST_OUTPUT The captured raw stdout.
# @exitcode ? The exit code of the executed command.
_capture.stdout_raw() {
  # shellcheck disable=SC2034
  LC_ALL=C IFS= read -rd '' TEST_OUTPUT < <("$@" 2> /dev/null)

  wait "$!"
  return "$?"
}
