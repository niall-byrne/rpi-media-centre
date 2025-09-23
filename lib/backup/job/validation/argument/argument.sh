#!/bin/bash

# pictl backup job validation argument library

set -eo pipefail

_backup_job_validation_argument() {
  _backup_job_validation_argument_remote_target
  _backup_job_validation_argument_tarball_versions
}
