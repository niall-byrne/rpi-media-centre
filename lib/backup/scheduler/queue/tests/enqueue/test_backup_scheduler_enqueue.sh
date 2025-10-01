#!/bin/bash

setup() {
  _mock.create _cli_log_error

  _mock.create _is_disk_mounted_all
  _mock.create _backup_scheduler_queue_make
  _mock.create _control_lock

  _mock.create _backup_scheduler_queue_enqueue_group
  _mock.create _backup_scheduler_queue_enqueue_name
  _mock.create _cli_log_success
}

@parametrize_with_entities() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ENTITY_TYPE;TEST_ENTITY_VALUE;TEST_EXPECTED_COMMAND" \
    "group__;group;group1;_backup_scheduler_queue_enqueue_group" \
    "name___;name;name1;_backup_scheduler_queue_enqueue_name"
}

test_backup_scheduler_queue_enqueue__invalid_entity__logs_error_message() {
  _backup_scheduler_queue_enqueue "invalid_entity" "unused_value"

  _cli_log_error.mock.assert_called_once_with \
    "1(BACKUP SCHEDULER: Unknown entity type 'invalid_entity' !)"
}

test_backup_scheduler_queue_enqueue__invalid_entity__returns_status_code_127() {
  _capture.rc _backup_scheduler_queue_enqueue "invalid_entity" "unused_value"

  assert_rc "127"
}

test_backup_scheduler_queue_enqueue__invalid_entity__calls_only_specific_dependencies() {
  _mock.sequence.record.start

  _backup_scheduler_queue_enqueue "invalid_entity" "unused_value"

  _mock.sequence.assert_is \
    "_cli_log_error"
}

test_backup_scheduler_queue_enqueue__@vary__checks_disks_are_mounted() {
  _backup_scheduler_queue_enqueue "${TEST_ENTITY_TYPE}" "${TEST_ENTITY_VALUE}"

  _is_disk_mounted_all.mock.assert_called_once_with ""
}

@parametrize_with_entities \
  test_backup_scheduler_queue_enqueue__@vary__checks_disks_are_mounted

test_backup_scheduler_queue_enqueue__@vary__ensure_queues_exist() {
  _backup_scheduler_queue_enqueue "${TEST_ENTITY_TYPE}" "${TEST_ENTITY_VALUE}"

  _backup_scheduler_queue_make.mock.assert_called_once_with ""
}

@parametrize_with_entities \
  test_backup_scheduler_queue_enqueue__@vary__ensure_queues_exist

test_backup_scheduler_queue_enqueue__@vary__acquires_scheduler_lock() {
  _backup_scheduler_queue_enqueue "${TEST_ENTITY_TYPE}" "${TEST_ENTITY_VALUE}"

  _control_lock.mock.assert_called_once_with \
    "1(rpi-backup-scheduler.pid) 2(15)"
}

@parametrize_with_entities \
  test_backup_scheduler_queue_enqueue__@vary__acquires_scheduler_lock

test_backup_scheduler_queue_enqueue__@vary__calls_the_correct_enqueue_command() {
  _backup_scheduler_queue_enqueue "${TEST_ENTITY_TYPE}" "${TEST_ENTITY_VALUE}"

  "${TEST_EXPECTED_COMMAND}".mock.assert_called_once_with \
    "1(${TEST_ENTITY_VALUE})"
}

@parametrize_with_entities \
  test_backup_scheduler_queue_enqueue__@vary__calls_the_correct_enqueue_command

test_backup_scheduler_queue_enqueue__@vary__disables_file_validation_when_enqueing() {
  "${TEST_EXPECTED_COMMAND}".mock.set.keywords "RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY"
  _backup_scheduler_queue_enqueue "${TEST_ENTITY_TYPE}" "${TEST_ENTITY_VALUE}"

  "${TEST_EXPECTED_COMMAND}".mock.assert_called_once_with \
    "1(${TEST_ENTITY_VALUE}) RPI_BACKUP_JOB_VALIDATORS_DISABLED_ARRAY('filesystem')"
}

@parametrize_with_entities \
  test_backup_scheduler_queue_enqueue__@vary__disables_file_validation_when_enqueing

test_backup_scheduler_queue_enqueue__@vary__logs_success_message() {
  _backup_scheduler_queue_enqueue "${TEST_ENTITY_TYPE}" "${TEST_ENTITY_VALUE}"

  _cli_log_success.mock.assert_called_once_with \
    "1(BACKUP SCHEDULER: Scheduling complete !)"
}

@parametrize_with_entities \
  test_backup_scheduler_queue_enqueue__@vary__logs_success_message

test_backup_scheduler_queue_enqueue__@vary__calls_only_specific_dependencies() {
  _mock.sequence.record.start

  _backup_scheduler_queue_enqueue "${TEST_ENTITY_TYPE}" "${TEST_ENTITY_VALUE}"

  _mock.sequence.assert_is \
    "_is_disk_mounted_all" \
    "_backup_scheduler_queue_make" \
    "_control_lock" \
    "${TEST_EXPECTED_COMMAND}" \
    "_cli_log_success"
}

@parametrize_with_entities \
  test_backup_scheduler_queue_enqueue__@vary__calls_only_specific_dependencies
