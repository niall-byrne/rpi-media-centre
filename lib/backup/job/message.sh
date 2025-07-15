#!/bin/bash

# pictl backup job message library

set -eo pipefail

_backup_job_message_remote_param() {
  _cli_pretty_header "Valid S3 Parameters:"
  _cli_pretty_bullet_point "STANDARD " "3" | _cli_pretty_strip_trailing_newline
  _cli_pretty_brackets_style_1 "(default)"
  _cli_pretty_bullet_point "REDUCED_REDUNDANCY" "3"
  _cli_pretty_bullet_point "STANDARD_IA" "3"
  _cli_pretty_bullet_point "ONEZONE_IA" "3"
  _cli_pretty_bullet_point "INTELLIGENT_TIERING" "3"
  _cli_pretty_bullet_point "GLACIER" "3"
  _cli_pretty_bullet_point "DEEP_ARCHIVE" "3"
  _cli_pretty_bullet_point "GLACIER_IR" "3"
  _cli_pretty_info " *Please see https://aws.amazon.com/s3/storage-classes for details."
}

_backup_job_message_queue() {
  _cli_pretty_header "Valid Queues:"
  _cli_pretty_justify_left "10" "rsync" | _cli_pretty_bullet_point - "3" | _cli_pretty_strip_trailing_newline
  _cli_pretty_info "- create rsync copy"
  _cli_pretty_justify_left "10" "tar" | _cli_pretty_bullet_point - "3" | _cli_pretty_strip_trailing_newline
  _cli_pretty_info "- create tar bundle"
  _cli_pretty_justify_left "10" "upload" | _cli_pretty_bullet_point - "3" | _cli_pretty_strip_trailing_newline
  _cli_pretty_info "- upload tar bundle to remote storage"
}

_backup_job_message_remote_target() {
  _cli_pretty_header "Valid Remote Targets:"
  _cli_pretty_bullet_point "s3:" "3" | _cli_pretty_strip_trailing_newline
  _cli_pretty_detail "//" | _cli_pretty_strip_trailing_newline
  _cli_pretty_entity "bucket_name" | _cli_pretty_strip_trailing_newline
  _cli_pretty_detail "/" | _cli_pretty_strip_trailing_newline
  _cli_pretty_entity "path_name"
}

_backup_job_message_tarball_versions() {
  _cli_pretty_header "Valid Version Count:"
  _cli_pretty_bullet_point "any number between" "3" | _cli_pretty_strip_trailing_newline
  _cli_pretty_detail " 1 " | _cli_pretty_strip_trailing_newline
  _cli_pretty_entity "and" | _cli_pretty_strip_trailing_newline
  _cli_pretty_detail " 9 " | _cli_pretty_strip_trailing_newline
  _cli_pretty_brackets_style_1 "(inclusive)"
}
