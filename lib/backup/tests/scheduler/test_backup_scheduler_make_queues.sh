#!/bin/bash

setup_suite() {
  _fixture_escape_rpi_vars
}

setup() {
  _mock.create stdlib.security.path.make.dir
  _mock.create stdlib.security.path.secure
}

test_backup_scheduler_make_queues__calls_stdlib_security_path_make_dir() {
  _backup_scheduler_make_queues

  stdlib.security.path.make.dir.mock.assert_count_is "3"
  stdlib.security.path.make.dir.mock.assert_calls_are \
    "\${RPI_BACKUP_PATH_QUEUE_ROOT}/rsync \${RPI_SVC_USERNAME} \${RPI_SVC_GROUPNAME} 700" \
    "\${RPI_BACKUP_PATH_QUEUE_ROOT}/tarball \${RPI_SVC_USERNAME} \${RPI_SVC_GROUPNAME} 700" \
    "\${RPI_BACKUP_PATH_QUEUE_ROOT}/upload \${RPI_SVC_USERNAME} \${RPI_SVC_GROUPNAME} 700"
}

test_backup_scheduler_make_queues__calls_stdlib_security_path_secure() {
  _backup_scheduler_make_queues

  stdlib.security.path.secure.mock.assert_called_once_with \
    "\${RPI_BACKUP_PATH_QUEUE_ROOT} \${RPI_SVC_USERNAME} \${RPI_SVC_GROUPNAME} 700"
}
