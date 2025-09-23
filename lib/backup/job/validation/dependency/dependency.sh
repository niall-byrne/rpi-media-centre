#!/bin/bash

# pictl backup job validation dependency library

set -eo pipefail

_backup_job_validation_dependency() {
  _backup_job_validation_dependency_remote_target
  _backup_job_validation_dependency_rsync
  _backup_job_validation_dependency_tarball
}
