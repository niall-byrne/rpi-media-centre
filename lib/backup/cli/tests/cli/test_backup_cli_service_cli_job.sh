#!/bin/bash

setup() {
  _mock.create _backup_job
  _mock.create _backup_job_usage
}

test_backup_cli_service_cli_job__no_args_____displays_error() {
  _backup_cli_service_cli_job

  _backup_job_usage.mock.assert_called_once_with ""
}

test_backup_cli_service_cli_job__no_args_____does_not_process_the_job() {
  _backup_cli_service_cli_job

  _backup_job.mock.assert_not_called
}

test_backup_cli_service_cli_job__valid_args__does_not_display_error() {
  _backup_cli_service_cli_job valid_arg_1 valid_arg_2

  _backup_job_usage.mock.assert_not_called
}

test_backup_cli_service_cli_job__valid_args__processes_the_job() {
  _backup_cli_service_cli_job valid_arg_1 valid_arg_2

  _backup_job.mock.assert_called_once_with \
    "1(valid_arg_1) 2(valid_arg_2)"
}
