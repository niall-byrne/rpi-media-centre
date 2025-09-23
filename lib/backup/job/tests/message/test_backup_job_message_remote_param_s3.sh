#!/bin/bash

setup() {
  _fixture_escape_rpi_vars
}

test_backup_job_message_remote_param_s3() {
  _capture.output _backup_job_message_remote_param_s3

  assert_snapshot "__fixtures__/message_remote_param_s3.txt"
}
