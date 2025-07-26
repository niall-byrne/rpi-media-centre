#!/bin/bash

setup() {
  _fixture_escape_rpi_vars
}

test_backup_job_message_remote_target() {
  _capture_output _backup_job_message_remote_target

  assert_snapshot "__fixtures__/message_remote_target.txt"
}
