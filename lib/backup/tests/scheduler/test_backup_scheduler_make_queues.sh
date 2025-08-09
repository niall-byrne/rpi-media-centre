#!/bin/bash

setup_suite() {
  _fixture_escape_rpi_vars
}

setup() {
  _mock.create _security_path_mkdir
  _mock.create _security_path_secure
}

test_backup_scheduler_make_queues__calls_security_path_mkdir() {
  _backup_scheduler_make_queues

  _security_path_mkdir.mock.assert_count_is "3"
  _security_path_mkdir.mock.assert_calls_are \
    "\${RPI_BACKUP_PATH_QUEUE_ROOT}/rsync \${RPI_SVC_USERNAME} \${RPI_SVC_GROUPNAME} 700" \
    "\${RPI_BACKUP_PATH_QUEUE_ROOT}/tarball \${RPI_SVC_USERNAME} \${RPI_SVC_GROUPNAME} 700" \
    "\${RPI_BACKUP_PATH_QUEUE_ROOT}/upload \${RPI_SVC_USERNAME} \${RPI_SVC_GROUPNAME} 700"
}

test_backup_scheduler_make_queues__calls_security_path_secure() {
  _backup_scheduler_make_queues

  _security_path_secure.mock.assert_called_once_with \
    "\${RPI_BACKUP_PATH_QUEUE_ROOT} \${RPI_SVC_USERNAME} \${RPI_SVC_GROUPNAME} 700"
}
