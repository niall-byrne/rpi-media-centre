#!/bin/bash

# stdlib testing assertion capture library

builtin set -eo pipefail

_capture_assertion_failure() {
  # $@: the assertion commands to execute
  local output
  local rc

  set +e
  LC_ALL=C IFS= builtin read -rd '' output < <("$@" 2>&1)
  set -e

  wait "$!"
  rc="$?"

  if [[ ${rc} -eq 0 ]]; then
    fail " $(_testing.assert.message.get ASSERT_ERROR_DID_NOT_FAIL "${1}")"
  fi

  # shellcheck disable=SC2034
  TEST_OUTPUT="$(echo "${output}" | sed -E '/^FAILURE/d' | sed -E '/(^\.\/|^\/)[^:]+:[0-9]+:.*/d')"
}
