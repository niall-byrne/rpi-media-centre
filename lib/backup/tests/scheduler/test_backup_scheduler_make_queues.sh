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
    "1(\${RPI_BACKUP_PATH_QUEUE_ROOT}/rsync) 2(\${RPI_SVC_USERNAME}) 3(\${RPI_SVC_GROUPNAME}) 4(700)" \
    "1(\${RPI_BACKUP_PATH_QUEUE_ROOT}/tarball) 2(\${RPI_SVC_USERNAME}) 3(\${RPI_SVC_GROUPNAME}) 4(700)" \
    "1(\${RPI_BACKUP_PATH_QUEUE_ROOT}/upload) 2(\${RPI_SVC_USERNAME}) 3(\${RPI_SVC_GROUPNAME}) 4(700)"
}

test_backup_scheduler_make_queues__calls_stdlib_security_path_secure() {
  _backup_scheduler_make_queues

  stdlib.security.path.secure.mock.assert_called_once_with \
    "1(\${RPI_BACKUP_PATH_QUEUE_ROOT}) 2(\${RPI_SVC_USERNAME}) 3(\${RPI_SVC_GROUPNAME}) 4(700)"
}
