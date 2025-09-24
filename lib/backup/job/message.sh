#!/bin/bash

# pictl backup job message library

set -eo pipefail

_backup_job_message_destination_path() {
  _cli_pretty_header "Valid Destination Path:"
  {
    _cli_pretty_bullet_point "path" "3"
    _cli_pretty_detail ":"
    _cli_pretty_entity "permission"
  } | stdlib.string.lines.join_pipe
  _cli_pretty_info " *Please check the path value and it's permission."
}

_backup_job_message_keyfile_path() {
  _cli_pretty_info " *Please check the encryption key path value."
}

_backup_job_message_queue() {
  _cli_pretty_header "Valid Queues:"
  {
    stdlib.string.justify.left "10" "rsync" | _cli_pretty_bullet_point_pipe - "3"
    _cli_pretty_info "- create rsync copy"
  } | stdlib.string.lines.join_pipe
  {
    stdlib.string.justify.left "10" "tar" | _cli_pretty_bullet_point_pipe - "3"
    _cli_pretty_info "- create tar bundle"
  } | stdlib.string.lines.join_pipe
  {
    stdlib.string.justify.left "10" "upload" | _cli_pretty_bullet_point_pipe - "3"
    _cli_pretty_info "- upload tar bundle to remote storage"
  } | stdlib.string.lines.join_pipe
}

_backup_job_message_remote_param() {
  _cli_pretty_header "Valid S3 Parameters:"
  {
    _cli_pretty_bullet_point "STANDARD " "3"
    _cli_pretty_brackets_style_1 "(default)"
  } | stdlib.string.lines.join_pipe
  _cli_pretty_bullet_point "REDUCED_REDUNDANCY" "3"
  _cli_pretty_bullet_point "STANDARD_IA" "3"
  _cli_pretty_bullet_point "ONEZONE_IA" "3"
  _cli_pretty_bullet_point "INTELLIGENT_TIERING" "3"
  _cli_pretty_bullet_point "GLACIER" "3"
  _cli_pretty_bullet_point "DEEP_ARCHIVE" "3"
  _cli_pretty_bullet_point "GLACIER_IR" "3"
  _cli_pretty_info " *Please see https://aws.amazon.com/s3/storage-classes for details."
}

_backup_job_message_remote_target() {
  _cli_pretty_header "Valid Remote Targets:"
  {
    _cli_pretty_bullet_point "s3:" "3"
    _cli_pretty_detail "//"
    _cli_pretty_entity "bucket_name"
    _cli_pretty_detail "/"
    _cli_pretty_entity "path_name"
  } | stdlib.string.lines.join_pipe
}

_backup_job_message_source_path() {
  _cli_pretty_info " *Please check the source path value."
}

_backup_job_message_tarball_versions() {
  _cli_pretty_header "Valid Version Count:"
  {
    _cli_pretty_bullet_point "any number between" "3"
    _cli_pretty_detail " 1 "
    _cli_pretty_entity "and"
    _cli_pretty_detail " 9 "
    _cli_pretty_brackets_style_1 "(inclusive)"
  } | stdlib.string.lines.join_pipe
}
