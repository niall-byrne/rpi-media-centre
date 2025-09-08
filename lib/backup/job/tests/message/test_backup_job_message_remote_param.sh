#!/bin/bash

setup() {
  _fixture_escape_rpi_vars
}

test_backup_job_message_remote_param() {
  _capture.output _backup_job_message_remote_param

  assert_snapshot "__fixtures__/message_remote_param.txt"
}
