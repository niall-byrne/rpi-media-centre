#!/bin/bash

# stdlib testing output capture library

builtin set -eo pipefail

_capture.output() {
  # $@: the commands to execute

  # shellcheck disable=SC2034
  TEST_OUTPUT="$("$@" 2>&1)"
}

_capture.output_raw() {
  # $@: the commands to execute

  # shellcheck disable=SC2034
  LC_ALL=C IFS= builtin read -rd '' TEST_OUTPUT < <("$@" 2>&1)

  wait "$!"
  return "$?"
}
