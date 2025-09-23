#!/bin/bash

setup() {
  _mock.create _backup_job_validation_argument_remote_target
  _mock.create _backup_job_validation_argument_tarball_versions
}

test_backup_job_validation_argument__validates_the_remote_target() {
  _backup_job_validation_argument

  _backup_job_validation_argument_remote_target.mock.assert_called_once_with ""
}

test_backup_job_validation_argument__validates_the_tarball_version_count() {
  _backup_job_validation_argument

  _backup_job_validation_argument_tarball_versions.mock.assert_called_once_with ""
}
