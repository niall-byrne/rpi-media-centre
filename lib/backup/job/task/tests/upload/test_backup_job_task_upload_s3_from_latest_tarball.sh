#!/bin/bash

setup() {
  _mock.create _control_retries
}

test_backup_job_task_upload_s3_from_latest_tarball__success__calls_control_retries() {
  _backup_job_task_upload_s3_from_latest_tarball

  _control_retries.mock.assert_called_once_with \
    "1(5) 2(_backup_job_task_upload_s3_from_latest_tarball_retryable)"
}
