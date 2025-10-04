#!/bin/bash

# shellcheck disable=SC2034
setup_suite() {
  empty_array=()
}

setup() {
  _mock.create _backup_job_parse_destination_folders
  _mock.create _backup_job_validation
}

# shellcheck disable=SC2034
test_backup_manifest_line_validate__no_disabled_validators_________calls_job_parse_destination_folders() {
  _backup_manifest_line_validate

  _backup_job_parse_destination_folders.mock.assert_called_once_with ""
}

# shellcheck disable=SC2034
test_backup_manifest_line_validate__no_disabled_validators_________calls_job_validation_with_filesystem_checks_disabled() {
  _backup_manifest_line_validate

  _backup_job_validation.mock.assert_called_once_with \
    "1(_backup_manifest_line_log_invalid)"
}

# shellcheck disable=SC2034
test_backup_manifest_line_validate__no_disabled_validators_________executes_in_subshell() {
  local mutation_variable="no mutation"

  _backup_job_validation.mock.set.subcommand "mutation_variable='mutation'"

  _backup_manifest_line_validate

  assert_equals "no mutation" "${mutation_variable}"
}
