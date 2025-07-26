#!/bin/bash

setup() {
  _fixture_escape_rpi_vars
}

test_backup_job_message_queue() {
  _capture_output _backup_job_message_queue

  assert_snapshot "__fixtures__/message_queue.txt"
}
