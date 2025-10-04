#!/bin/bash

setup() {
  _mock.create _cli_pretty_title
  _mock.create _disk_manifest_help
}

# shellcheck disable=SC2034
test_disk_cli_manifest_cli_details__logs_success_message() {
  local RPI_MANIFEST_CRYPT="placeholder"

  _disk_cli_manifest_cli_details

  _cli_pretty_title.mock.assert_called_once_with \
    "1(** Details for the placeholder file **)"
}

test_disk_cli_manifest_cli_details__checks_the_manifest() {
  _disk_cli_manifest_cli_details

  _disk_manifest_help.mock.assert_called_once_with ""
}
