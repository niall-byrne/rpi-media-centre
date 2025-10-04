#!/bin/bash

setup() {
  _mock.create _disk_manifest_command_all
  _mock.create _event_script
}

test_disk_manifest_command_mount__calls_event_scripts() {
  _disk_manifest_command_mount

  _event_script.mock.assert_count_is "2"
  _event_script.mock.assert_calls_are \
    "1(event-disk-before-mounted.sh)" \
    "1(event-disk-after-mounted.sh)"
}

test_disk_manifest_command_mount__calls_disk_manifest_command_all() {
  _disk_manifest_command_mount

  _disk_manifest_command_all.mock.assert_called_once_with \
    "1(_disk_unlock)"
}

test_disk_manifest_command_mount__event_scripts_are_correctly_sequenced() {
  _mock.sequence.record.start

  _disk_manifest_command_mount

  _mock.sequence.assert_is \
    "_event_script" \
    "_disk_manifest_command_all" \
    "_event_script"
}
