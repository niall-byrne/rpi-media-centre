#!/bin/bash

# stdlib testing rc capture library

builtin set -eo pipefail

_capture.rc() {
  # $@: the commands to execute

  "$@"

  # shellcheck disable=SC2034
  TEST_RC="$?"
}
