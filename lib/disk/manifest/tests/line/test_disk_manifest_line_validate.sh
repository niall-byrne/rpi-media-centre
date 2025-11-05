#!/bin/bash

setup() {
  _mock.create _disk_manifest_validation
  _mock.create _help_callback
}

test_disk_manifest_line_validate__validation_fails___calls_help_function() {
  _disk_manifest_validation.mock.set.rc 1

  _disk_manifest_line_validate _help_callback

  _help_callback.mock.assert_called_once_with ""
}

test_disk_manifest_line_validate__validation_fails___returns_status_code_127() {
  _disk_manifest_validation.mock.set.rc 1

  _capture.rc _disk_manifest_line_validate _help_callback

  assert_rc "127"
}

test_disk_manifest_line_validate__validation_passes__does_not_call_help_function() {
  _disk_manifest_validation.mock.set.rc 0

  _disk_manifest_line_validate _help_callback

  _help_callback.mock.assert_not_called
}

test_disk_manifest_line_validate__validation_passes__returns_status_code_0() {
  _disk_manifest_validation.mock.set.rc 0

  _capture.rc _disk_manifest_line_validate _help_callback

  assert_rc "0"
}
