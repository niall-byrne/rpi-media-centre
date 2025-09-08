#!/bin/bash

setup() {
  _mock.create _cli_log_notice
  _mock.create stdlib.security.path.assert.is_secure
  _mock.create cp
  _mock.create stdlib.io.stdin.prompt
  _mock.create stdlib.security.path.make.dir
  _mock.create _docker_compose_filtered_env
  _mock.create stdlib.io.path.query.is_file

  stdlib.io.stdin.prompt.mock.set.keywords "_STDLIB_PASSWORD_BOOLEAN"
}

@parametrize_with_config() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_IS_FILE_RC;TEST_SOURCE_USED" \
    "samba_yml_does_not_exist;1;./services/samba/config.yml" \
    "samba_yml_exists________;0;/etc/rpi/samba.yml"
}

test_configuration_samba__@vary__copies_correct_config() {
  local RPI_SAMBA_PATH_CONFIG="/config"
  stdlib.io.path.query.is_file.mock.set.rc "${TEST_IS_FILE_RC}"

  _configuration_samba

  cp.mock.assert_called_once_with \
    "1(-a) 2(${TEST_SOURCE_USED}) 3(${RPI_SAMBA_PATH_CONFIG}/config.yml)"
}

@parametrize_with_config \
  test_configuration_samba__@vary__copies_correct_config

test_configuration_samba__samba_yml_does_not_exist__does_not_log_a_notice_message() {
  local RPI_SAMBA_PATH_CONFIG="/config"
  stdlib.io.path.query.is_file.mock.set.rc 1

  _configuration_samba

  _cli_log_notice.mock.assert_not_called
}

test_configuration_samba__samba_yml_exists__________logs_notice_message() {
  local RPI_SAMBA_PATH_CONFIG="/config"
  stdlib.io.path.query.is_file.mock.set.rc 0

  _configuration_samba

  _cli_log_notice.mock.assert_called_once_with \
    "1(-- loading /etc/rpi/samba.yml file ... --)"
}

test_configuration_samba__samba_yml_does_not_exist__does_not_check_file_security() {
  local RPI_SAMBA_PATH_CONFIG="/config"
  stdlib.io.path.query.is_file.mock.set.rc 1

  _configuration_samba

  stdlib.security.path.assert.is_secure.mock.assert_not_called
}

test_configuration_samba__samba_yml_exists__________checks_file_security() {
  local RPI_SAMBA_PATH_CONFIG="/config"
  stdlib.io.path.query.is_file.mock.set.rc 0

  _configuration_samba

  stdlib.security.path.assert.is_secure.mock.assert_called_once_with \
    "1(/etc/rpi/samba.yml) 2(root) 3(root) 4(600)"
}

test_configuration_samba__@vary__prompts_for_credentials() {
  local RPI_SAMBA_PATH_CONFIG="/config"
  stdlib.io.path.query.is_file.mock.set.rc "${TEST_IS_FILE_RC}"

  _configuration_samba

  stdlib.io.stdin.prompt.mock.assert_calls_are \
    "1(RPI_SAMBA_CREDENTIALS_USERNAME) 2(Enter Samba Username: ) _STDLIB_PASSWORD_BOOLEAN()" \
    "1(RPI_SAMBA_CREDENTIALS_PASSWORD) 2(Enter Samba Password: ) _STDLIB_PASSWORD_BOOLEAN(1)" \
    "1(RPI_SAMBA_SUBNET) 2(Enter Samba Network CIDR: ) _STDLIB_PASSWORD_BOOLEAN()"
}

@parametrize_with_config \
  test_configuration_samba__@vary__prompts_for_credentials

test_configuration_samba__@vary__creates_dir_for_docker_env_file() {
  local RPI_SAMBA_PATH_CONFIG="/config"
  stdlib.io.path.query.is_file.mock.set.rc "${TEST_IS_FILE_RC}"

  _configuration_samba

  stdlib.security.path.make.dir.mock.assert_called_once_with \
    "1(/var/run/rpi) 2(root) 3(root) 4(700)"
}

@parametrize_with_config \
  test_configuration_samba__@vary__creates_dir_for_docker_env_file

test_configuration_samba__@vary__creates_docker_env_file() {
  local RPI_SAMBA_PATH_CONFIG="/config"
  stdlib.io.path.query.is_file.mock.set.rc "${TEST_IS_FILE_RC}"

  _configuration_samba

  _docker_compose_filtered_env.mock.assert_called_once_with \
    "1(SAMBA_) 2(/var/run/rpi/samba.env)"
}

@parametrize_with_config \
  test_configuration_samba__@vary__creates_docker_env_file
