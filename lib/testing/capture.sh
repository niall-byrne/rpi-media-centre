#!/bin/bash

# pictl testing capture library

set -eo pipefail

_capture_stderr() {
  # $@: the commands to execute

  local CAPTURE_RC

  exec 3>&1
  # shellcheck disable=SC2034
  TEST_OUTPUT="$("$@" 2>&1 1> /dev/null)"
  CAPTURE_RC="$?"
  exec 3>&-

  return "${CAPTURE_RC}"
}

_capture_stderr_raw() {
  # $@: the commands to execute

  exec 3>&1
  # shellcheck disable=SC2034
  LC_ALL=C IFS= read -rd '' TEST_OUTPUT < <("$@" 2>&1 1> /dev/null)
  exec 3>&-

  wait "$!"
  return "$?"
}

_capture_stdout() {
  # $@: the commands to execute

  # shellcheck disable=SC2034
  TEST_OUTPUT="$("$@" 2> /dev/null)"
}

_capture_stdout_raw() {
  # $@: the commands to execute

  # shellcheck disable=SC2034
  LC_ALL=C IFS= read -rd '' TEST_OUTPUT < <("$@" 2> /dev/null)

  wait "$!"
  return "$?"
}

_capture_output() {
  # $@: the commands to execute

  # shellcheck disable=SC2034
  TEST_OUTPUT="$("$@" 2>&1)"
}

_capture_output_raw() {
  # $@: the commands to execute

  # shellcheck disable=SC2034
  LC_ALL=C IFS= read -rd '' TEST_OUTPUT < <("$@" 2>&1)

  wait "$!"
  return "$?"
}

_capture_rc() {
  # $@: the commands to execute

  "$@"

  # shellcheck disable=SC2034
  TEST_RC="$?"
}
