#!/bin/bash

setup() {
  _mock.create _is_disk_mounted_all
  _mock.create _backup_scheduler_make_queues
}

test_backup_cli_service_cli_before_all__calls_dependencies_in_sequence() {
  _mock.sequence.record.start

  _backup_cli_service_cli_before_all

  _mock.sequence.assert_is \
    "_is_disk_mounted_all" \
    "_backup_scheduler_make_queues"
}

test_backup_cli_service_cli_before_all__checks_disks_are_all_mounted() {
  _backup_cli_service_cli_before_all

  _is_disk_mounted_all.mock.assert_called_once_with ""
}

test_backup_cli_service_cli_before_all__creates_scheduler_queues() {
  _backup_cli_service_cli_before_all

  _backup_scheduler_make_queues.mock.assert_called_once_with ""
}
