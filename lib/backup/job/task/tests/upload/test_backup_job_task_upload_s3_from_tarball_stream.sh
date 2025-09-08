#!/bin/bash

setup() {
  _mock.create _backup_job_task_upload_s3_estimate_tarball_size
  _mock.create _control_retries
}

test_backup_job_task_upload_s3_from_tarball_stream__success__calls_dependencies_in_order() {
  _mock.sequence.record.start

  _backup_job_task_upload_s3_from_tarball_stream

  _mock.sequence.assert_is \
    "_backup_job_task_upload_s3_estimate_tarball_size" \
    "_control_retries"
}

test_backup_job_task_upload_s3_from_tarball_stream__success__estimates_tar_size_correctly() {
  _backup_job_task_upload_s3_from_tarball_stream

  _backup_job_task_upload_s3_estimate_tarball_size.mock.assert_called_once_with ""
}

test_backup_job_task_upload_s3_from_tarball_stream__success__calls_control_retries_with_correct_args() {
  _backup_job_task_upload_s3_from_tarball_stream

  _control_retries.mock.assert_called_once_with \
    "1(5) 2(_backup_job_task_upload_s3_from_tarball_stream_retryable)"
}
