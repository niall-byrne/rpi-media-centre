#!/bin/bash

setup() {
  _mock.create stdlib.io.path.query.is_file
  _mock.create _cli_log_notice
  _mock.create stdlib.security.path.assert.is_secure

  _mock.create _test_mock
}

@parametrize_with_args() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_COMMAND_ARGS_DEFINITION" \
    "0_arguments______;;" \
    "1_argument_______;arg1" \
    "2_arguments______;arg1|arg2"
}

# shellcheck disable=SC2034
test_configuration_pictl_secure_load__config_exists__________quiet_mode____@vary__does_not_log_notice_message() {
  local RPI_CONFIGURATION_QUIET_LOAD="1"
  local command_args=()

  stdlib.io.path.query.is_file.mock.set.rc 0
  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _configuration_pictl_secure_load _test_mock "${command_args[@]}"

  _cli_log_notice.mock.assert_not_called
}

# shellcheck disable=SC2034
test_configuration_pictl_secure_load__config_exists__________verbose_mode__@vary__logs_notice_message() {
  local RPI_CONFIGURATION_QUIET_LOAD=""
  local command_args=()

  stdlib.io.path.query.is_file.mock.set.rc 0
  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _configuration_pictl_secure_load _test_mock "${command_args[@]}"

  _cli_log_notice.mock.assert_called_once_with \
    "1(-- loading /etc/rpi/config file ... --)"
}

# shellcheck disable=SC2034
test_configuration_pictl_secure_load__config_does_not_exist__quiet_mode____@vary__does_not_log_notice_message() {
  local RPI_CONFIGURATION_QUIET_LOAD="1"
  local command_args=()

  stdlib.io.path.query.is_file.mock.set.rc 1
  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _configuration_pictl_secure_load _test_mock "${command_args[@]}"

  _cli_log_notice.mock.assert_not_called
}

# shellcheck disable=SC2034
test_configuration_pictl_secure_load__config_does_not_exist__verbose_mode__@vary__does_not_log_notice_message() {
  local RPI_CONFIGURATION_QUIET_LOAD=""
  local command_args=()

  stdlib.io.path.query.is_file.mock.set.rc 1
  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _configuration_pictl_secure_load _test_mock "${command_args[@]}"

  _cli_log_notice.mock.assert_not_called
}

# shellcheck disable=SC2034
test_configuration_pictl_secure_load__config_exists__________quiet_mode____@vary__does_not_secure_configuration_file() {
  local RPI_CONFIGURATION_QUIET_LOAD="1"
  local command_args=()

  stdlib.io.path.query.is_file.mock.set.rc 0
  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _configuration_pictl_secure_load _test_mock "${command_args[@]}"

  stdlib.security.path.assert.is_secure.mock.assert_called_once_with \
    "1(/etc/rpi/config) 2(root) 3(root) 4(600)"
}

# shellcheck disable=SC2034
test_configuration_pictl_secure_load__config_exists__________verbose_mode__@vary__secures_configuration_file() {
  local RPI_CONFIGURATION_QUIET_LOAD=""
  local command_args=()

  stdlib.io.path.query.is_file.mock.set.rc 0
  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _configuration_pictl_secure_load _test_mock "${command_args[@]}"

  stdlib.security.path.assert.is_secure.mock.assert_called_once_with \
    "1(/etc/rpi/config) 2(root) 3(root) 4(600)"
}

# shellcheck disable=SC2034
test_configuration_pictl_secure_load__config_does_not_exist__quiet_mode____@vary__does_not_secure_configuration_file() {
  local RPI_CONFIGURATION_QUIET_LOAD="1"
  local command_args=()

  stdlib.io.path.query.is_file.mock.set.rc 1
  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _configuration_pictl_secure_load _test_mock "${command_args[@]}"

  stdlib.security.path.assert.is_secure.mock.assert_not_called
}

# shellcheck disable=SC2034
test_configuration_pictl_secure_load__config_does_not_exist__verbose_mode__@vary__does_not_secure_configuration_file() {
  local RPI_CONFIGURATION_QUIET_LOAD=""
  local command_args=()

  stdlib.io.path.query.is_file.mock.set.rc 1
  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _configuration_pictl_secure_load _test_mock "${command_args[@]}"

  stdlib.security.path.assert.is_secure.mock.assert_not_called
}

# shellcheck disable=SC2034
test_configuration_pictl_secure_load__config_exists__________quiet_mode____@vary__calls_load_command() {
  local RPI_CONFIGURATION_QUIET_LOAD="1"
  local command_args=()

  stdlib.io.path.query.is_file.mock.set.rc 0
  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _configuration_pictl_secure_load _test_mock "${command_args[@]}"

  _test_mock.mock.assert_called_once_with \
    "$(_mock.arg_string.from_array command_args)"
}

# shellcheck disable=SC2034
test_configuration_pictl_secure_load__config_exists__________verbose_mode__@vary__calls_load_command() {
  local RPI_CONFIGURATION_QUIET_LOAD=""
  local command_args=()

  stdlib.io.path.query.is_file.mock.set.rc 0
  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _configuration_pictl_secure_load _test_mock "${command_args[@]}"

  _test_mock.mock.assert_called_once_with \
    "$(_mock.arg_string.from_array command_args)"
}

# shellcheck disable=SC2034
test_configuration_pictl_secure_load__config_does_not_exist__quiet_mode____@vary__does_not_call_load_command() {
  local RPI_CONFIGURATION_QUIET_LOAD="1"
  local command_args=()

  stdlib.io.path.query.is_file.mock.set.rc 1
  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _configuration_pictl_secure_load _test_mock "${command_args[@]}"

  _test_mock.mock.assert_not_called
}

# shellcheck disable=SC2034
test_configuration_pictl_secure_load__config_does_not_exist__verbose_mode__@vary__does_not_call_load_command() {
  local RPI_CONFIGURATION_QUIET_LOAD=""
  local command_args=()

  stdlib.io.path.query.is_file.mock.set.rc 1
  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_ARGS_DEFINITION}"

  _configuration_pictl_secure_load _test_mock "${command_args[@]}"

  _test_mock.mock.assert_not_called
}
