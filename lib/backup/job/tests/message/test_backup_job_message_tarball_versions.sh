#!/bin/bash

setup() {
  _fixture_escape_rpi_vars
}

test_backup_job_message_tarball_versions() {
  _capture_output _backup_job_message_tarball_versions

  assert_snapshot "__fixtures__/message_tarball_versions.txt"
}
