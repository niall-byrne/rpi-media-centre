#!/bin/bash

# pictl shared cli pretty testing fixtures

set -eo pipefail

_fixture_mock_logs() {
  _mock.create _cli_log_success
  _mock.create _cli_log_info
  _mock.create _cli_log_notice
  _mock.create _cli_log_warning
  _mock.create _cli_log_error
}

_fixture_mock_pretty() {
  _mock.create _cli_pretty_columns
  _mock.create _cli_pretty_highlight
  _mock.create _cli_pretty_title
}
