#!/bin/bash

setup() {
  _fixture_escape_rpi_vars
}

test_backup_job_message_source_path() {
  _capture.output _backup_job_message_source_path

  assert_snapshot "__fixtures__/message_source_path.txt"
}
