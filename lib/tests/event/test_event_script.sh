#!/bin/bash

setup_suite() {
  RPI_EVENTS_PATH="$(mktemp -d)"
  TEST_USER="$(whoami)"

  echo "echo 'EVENT SCRIPT TRIGGERED!'" > "${RPI_EVENTS_PATH}/mock_event_script"

  stdlib.security.path.secure \
    "${RPI_EVENTS_PATH}/mock_event_script" \
    "${TEST_USER}" \
    "${TEST_USER}" \
    "700"
}

teardown_suite() {
  rm -r "${RPI_EVENTS_PATH}"
}

setup() {
  _mock.create stdlib.io.path.query.is_file
  _mock.create _cli_log_notice
  _mock.create stdlib.security.path.assert.is_secure
}

test_event_script__event_script_does_not_exist__does_not_execute_script() {
  stdlib.io.path.query.is_file.mock.set.rc 1

  _capture.output _event_script mock_event_script

  assert_output_null
}

test_event_script__event_script_exists__________event_folder_insecure_________________________logs_notice() {
  stdlib.io.path.query.is_file.mock.set.rc 0
  stdlib.security.path.assert.is_secure.mock.set.side_effects "return 1"

  _capture.output _event_script mock_event_script

  _cli_log_notice.mock.assert_called_once_with \
    "1(-- loading ${RPI_EVENTS_PATH}/mock_event_script file ... --)"
}

test_event_script__event_script_exists__________event_folder_insecure_________________________calls_security_assertion_correctly() {
  stdlib.io.path.query.is_file.mock.set.rc 0
  stdlib.security.path.assert.is_secure.mock.set.side_effects "return 1"

  _capture.output _event_script mock_event_script

  stdlib.security.path.assert.is_secure.mock.assert_called_once_with \
    "1(${RPI_EVENTS_PATH}) 2(root) 3(root) 4(700)"
}

test_event_script__event_script_exists__________event_folder_insecure_________________________does_not_execute_script() {
  stdlib.io.path.query.is_file.mock.set.rc 0
  stdlib.security.path.assert.is_secure.mock.set.side_effects "return 1"

  _capture.output _event_script mock_event_script

  assert_output_null
}

test_event_script__event_script_exists__________event_folder_secure____event_script_insecure__logs_notice() {
  stdlib.io.path.query.is_file.mock.set.rc 0
  stdlib.security.path.assert.is_secure.mock.set.side_effects "return 0" "return 1"

  _capture.output _event_script mock_event_script

  _cli_log_notice.mock.assert_called_once_with \
    "1(-- loading ${RPI_EVENTS_PATH}/mock_event_script file ... --)"
}

test_event_script__event_script_exists__________event_folder_secure____event_script_insecure__calls_security_assertion_correctly() {
  stdlib.io.path.query.is_file.mock.set.rc 0
  stdlib.security.path.assert.is_secure.mock.set.side_effects "return 0" "return 1"

  _capture.output _event_script mock_event_script

  stdlib.security.path.assert.is_secure.mock.assert_calls_are \
    "1(${RPI_EVENTS_PATH}) 2(root) 3(root) 4(700)" \
    "1(${RPI_EVENTS_PATH}/mock_event_script) 2(root) 3(root) 4(700)"
}

test_event_script__event_script_exists__________event_folder_secure____event_script_insecure__does_not_execute_script() {
  stdlib.io.path.query.is_file.mock.set.rc 0
  stdlib.security.path.assert.is_secure.mock.set.side_effects "return 0" "return 1"

  _capture.output _event_script mock_event_script

  assert_output_null
}

test_event_script__event_script_exists__________event_folder_secure____event_script_secure____logs_notice() {
  stdlib.io.path.query.is_file.mock.set.rc 0
  stdlib.security.path.assert.is_secure.mock.set.side_effects "return 0" "return 0"

  _capture.output _event_script mock_event_script

  _cli_log_notice.mock.assert_called_once_with \
    "1(-- loading ${RPI_EVENTS_PATH}/mock_event_script file ... --)"
}

test_event_script__event_script_exists__________event_folder_secure____event_script_secure____calls_security_assertion_correctly() {
  stdlib.io.path.query.is_file.mock.set.rc 0
  stdlib.security.path.assert.is_secure.mock.set.side_effects "return 0" "return 0"

  _capture.output _event_script mock_event_script

  stdlib.security.path.assert.is_secure.mock.assert_calls_are \
    "1(${RPI_EVENTS_PATH}) 2(root) 3(root) 4(700)" \
    "1(${RPI_EVENTS_PATH}/mock_event_script) 2(root) 3(root) 4(700)"
}

test_event_script__event_script_exists__________event_folder_secure____event_script_secure____does_not_execute_script() {
  stdlib.io.path.query.is_file.mock.set.rc 0
  stdlib.security.path.assert.is_secure.mock.set.side_effects "return 0" "return 0"

  _capture.output _event_script mock_event_script

  assert_output "EVENT SCRIPT TRIGGERED!"
}
