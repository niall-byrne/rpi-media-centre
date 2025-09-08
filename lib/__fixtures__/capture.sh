#!/bin/bash

# pictl shared cli testing capture fixtures

set -eo pipefail

_capture_logs() {
  # $@: the commands to execute

  _fixture_mock_logs

  "$@"
}

_capture_pretty() {
  # $@: the commands to execute

  _fixture_mock_pretty

  "$@"
}
