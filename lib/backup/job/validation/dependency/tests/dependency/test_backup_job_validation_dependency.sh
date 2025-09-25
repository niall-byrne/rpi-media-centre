#!/bin/bash

setup() {
  _mock.create _backup_job_validation_dependency_remote_target
  _mock.create _backup_job_validation_dependency_rsync
  _mock.create _backup_job_validation_dependency_tarball
}

test_backup_job_validation_dependency__calls_remote_target_check() {
  _backup_job_validation_dependency

  _backup_job_validation_dependency_remote_target.mock.assert_called_once_with ""
}

test_backup_job_validation_dependency__calls_rsync_check() {
  _backup_job_validation_dependency

  _backup_job_validation_dependency_rsync.mock.assert_called_once_with ""
}

test_backup_job_validation_dependency__calls_tarball_check() {
  _backup_job_validation_dependency

  _backup_job_validation_dependency_tarball.mock.assert_called_once_with ""
}