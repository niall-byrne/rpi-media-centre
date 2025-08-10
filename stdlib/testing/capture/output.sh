#!/bin/bash
# @file output.sh
# @brief A library for capturing command output for testing.
# @description
#   This library provides functions to capture the output of commands for testing purposes.

# stdlib testing output capture library

set -eo pipefail

# @description Captures the output of a command (stdout and stderr) into the TEST_OUTPUT variable.
# @arg $@ The command to execute.
# @set TEST_OUTPUT The captured output.
_capture.output() {
  # shellcheck disable=SC2034
  TEST_OUTPUT="$("$@" 2>&1)"
}

# @description Captures the raw output of a command (stdout and stderr) into the TEST_OUTPUT variable.
# This function is useful for capturing output that may contain special characters or newlines.
# @arg $@ The command to execute.
# @set TEST_OUTPUT The captured raw output.
# @exitcode ? The exit code of the executed command.
_capture.output_raw() {
  # shellcheck disable=SC2034
  LC_ALL=C IFS= read -rd '' TEST_OUTPUT < <("$@" 2>&1)

  wait "$!"
  return "$?"
}
