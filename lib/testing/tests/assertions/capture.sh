#!/bin/bash

_capture_assertion_failure() {
  # $@: the assertion commands to execute

  # shellcheck disable=SC2034
  TEST_OUTPUT="$(
    "${@}" | sed -z -e 's,/rpi-media-centre.*,,g' -e 's,FAILURE\n,,g' -e 's,/dev/fd.*,,g'
  )" && fail "The assertion '$1' did not fail!"
}
