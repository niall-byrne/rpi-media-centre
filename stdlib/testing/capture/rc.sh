#!/bin/bash
# @file rc.sh
# @brief A library for capturing command return codes for testing.
# @description
#   This library provides a function to capture the return code of a command for testing purposes.

# stdlib testing rc capture library

set -eo pipefail

# @description Captures the return code of a command into the TEST_RC variable.
# @arg $@ The command to execute.
# @set TEST_RC The captured return code.
_capture.rc() {
  "$@"

  # shellcheck disable=SC2034
  TEST_RC="$?"
}
