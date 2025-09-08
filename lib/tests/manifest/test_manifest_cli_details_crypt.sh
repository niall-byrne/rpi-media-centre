#!/bin/bash

setup() {
  _mock.create _cli_pretty_title
  _mock.create _disk_manifest_help
}

# shellcheck disable=SC2034
test_manifest_cli_details_crypt__logs_success_message() {
  local RPI_MANIFEST_CRYPT="placeholder"

  _manifest_cli_details_crypt

  _cli_pretty_title.mock.assert_called_once_with \
    "1(** Details for the placeholder file **)"
}

test_manifest_cli_details_crypt__checks_the_manifest() {
  _manifest_cli_details_crypt

  _disk_manifest_help.mock.assert_called_once_with ""
}
