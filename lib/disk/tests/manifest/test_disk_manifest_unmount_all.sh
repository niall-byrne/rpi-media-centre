#!/bin/bash

setup() {
  _mock.create _disk_manifest_all_command
  _mock.create _event_script
}

test_disk_manifest_unmount_all__calls_event_scripts() {
  _disk_manifest_unmount_all

  assert_equals "2" "$(_event_script.mock.get.count)"
  assert_equals \
    "event-disk-before-unmounted.sh
event-disk-after-unmounted.sh" \
    "$(_event_script.mock.get.calls)"
}

test_disk_manifest_unmount_all__calls_disk_manifest_all_command() {
  _disk_manifest_unmount_all

  assert_equals "1" "$(_disk_manifest_all_command.mock.get.count)"
  assert_equals "_disk_lock" "$(_disk_manifest_all_command.mock.get.call "1")"
}

test_disk_manifest_unmount_all__event_scripts_are_correctly_sequenced() {
  _disk_manifest_unmount_all

  _mock.sequence.assert_is "_event_script" "_disk_manifest_all_command" "_event_script"
}
