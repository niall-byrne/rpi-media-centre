#!/bin/bash

setup() {
  _mock.create _backup_job_message_remote_param_s3
}

test_backup_job_message_remote_param__calls_remote_param_s3() {
  _backup_job_message_remote_param

  _backup_job_message_remote_param_s3.mock.assert_called_once_with ""
}
