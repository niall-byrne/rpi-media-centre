#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/install/installer.sh"

setup_suite() {
  temp_folder="$(mktemp -d)"
}

setup() {
  _mock.create _cli_log_warning
  _mock.create _cli_log_success
  _mock.create systemctl

  cd "${RPI_WORKING_DIRECTORY}" || return 127
}

teardown_suite() {
  rm -r "${temp_folder}"
}

@parametrize_with_constants() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ROOT;TEST_USERNAME;TEST_GROUPNAME;TEST_SCHEDULER_START_TIME;TEST_SCHEDULING_HOUR" \
    "scenario1;/test/root;user1;group1;11;01"
}

# shellcheck disable=SC2034
_fixture_get_expected_service_content() {
  (
    export RPI_SVC_GROUPNAME
    export RPI_SVC_USERNAME
    export RPI_ROOT

    # shellcheck disable=SC2016
    envsubst '${RPI_SVC_GROUPNAME},${RPI_SVC_USERNAME},${RPI_ROOT}' < "services/backup/rpi-backup.service"
  )
}

# shellcheck disable=SC2034
_fixture_get_expected_timer_content() {
  (
    export RPI_BACKUP_SCHEDULER_START_TIME
    export RPI_ROOT

    # shellcheck disable=SC2016
    envsubst '${RPI_BACKUP_SCHEDULER_START_TIME},${RPI_ROOT}' < "services/backup/rpi-backup.timer"
  )
}

# shellcheck disable=SC2034
_fixture_get_expected_cron_content() {
  (
    export RPI_BACKUP_SCHEDULING_HOUR
    export RPI_SVC_USERNAME

    # shellcheck disable=SC2016
    envsubst '${RPI_BACKUP_SCHEDULING_HOUR},${RPI_SVC_USERNAME}' < "services/backup/crontab"
  )
}

test_install_installer_service_backup__@vary__logs_warning_message() {
  local RPI_INSTALLER_CRON_FILE_PATH="${temp_folder}/cron_file"
  local RPI_INSTALLER_SYSTEMD_SERVICE_PATH="${temp_folder}/systemd_service"
  local RPI_INSTALLER_SYSTEMD_TIMER_PATH="${temp_folder}/systemd_timer"
  local RPI_SVC_GROUPNAME="${TEST_GROUPNAME}"
  local RPI_SVC_USERNAME="${TEST_USERNAME}"
  local RPI_ROOT="${TEST_ROOT}"
  local RPI_BACKUP_SCHEDULER_START_TIME="${TEST_SCHEDULER_START_TIME}"
  local RPI_BACKUP_SCHEDULING_HOUR="${TEST_SCHEDULING_HOUR}"

  _installer_service_backup

  _cli_log_warning.mock.assert_called_once_with \
    "1(INSTALLER: Installing backup systemd service ...)"
}

@parametrize_with_constants \
  test_install_installer_service_backup__@vary__logs_warning_message

# shellcheck disable=SC2034
test_install_installer_service_backup__@vary__creates_service_file() {
  local RPI_INSTALLER_CRON_FILE_PATH="${temp_folder}/cron_file"
  local RPI_INSTALLER_SYSTEMD_SERVICE_PATH="${temp_folder}/systemd_service"
  local RPI_INSTALLER_SYSTEMD_TIMER_PATH="${temp_folder}/systemd_timer"
  local RPI_SVC_GROUPNAME="${TEST_GROUPNAME}"
  local RPI_SVC_USERNAME="${TEST_USERNAME}"
  local RPI_ROOT="${TEST_ROOT}"
  local RPI_BACKUP_SCHEDULER_START_TIME="${TEST_SCHEDULER_START_TIME}"
  local RPI_BACKUP_SCHEDULING_HOUR="${TEST_SCHEDULING_HOUR}"

  _installer_service_backup

  TEST_OUTPUT="$(_fixture_get_expected_service_content)"
  assert_snapshot "${RPI_INSTALLER_SYSTEMD_SERVICE_PATH}"
}

@parametrize_with_constants \
  test_install_installer_service_backup__@vary__creates_service_file

# shellcheck disable=SC2034
test_install_installer_service_backup__@vary__creates_timer_file() {
  local RPI_INSTALLER_CRON_FILE_PATH="${temp_folder}/cron_file"
  local RPI_INSTALLER_SYSTEMD_SERVICE_PATH="${temp_folder}/systemd_service"
  local RPI_INSTALLER_SYSTEMD_TIMER_PATH="${temp_folder}/systemd_timer"
  local RPI_SVC_GROUPNAME="${TEST_GROUPNAME}"
  local RPI_SVC_USERNAME="${TEST_USERNAME}"
  local RPI_ROOT="${TEST_ROOT}"
  local RPI_BACKUP_SCHEDULER_START_TIME="${TEST_SCHEDULER_START_TIME}"
  local RPI_BACKUP_SCHEDULING_HOUR="${TEST_SCHEDULING_HOUR}"

  _installer_service_backup

  TEST_OUTPUT="$(_fixture_get_expected_timer_content)"
  assert_snapshot "${RPI_INSTALLER_SYSTEMD_TIMER_PATH}"
}

@parametrize_with_constants \
  test_install_installer_service_backup__@vary__creates_timer_file

# shellcheck disable=SC2034
test_install_installer_service_backup__@vary__creates_cron_file() {
  local RPI_INSTALLER_CRON_FILE_PATH="${temp_folder}/cron_file"
  local RPI_INSTALLER_SYSTEMD_SERVICE_PATH="${temp_folder}/systemd_service"
  local RPI_INSTALLER_SYSTEMD_TIMER_PATH="${temp_folder}/systemd_timer"
  local RPI_SVC_GROUPNAME="${TEST_GROUPNAME}"
  local RPI_SVC_USERNAME="${TEST_USERNAME}"
  local RPI_ROOT="${TEST_ROOT}"
  local RPI_BACKUP_SCHEDULER_START_TIME="${TEST_SCHEDULER_START_TIME}"
  local RPI_BACKUP_SCHEDULING_HOUR="${TEST_SCHEDULING_HOUR}"

  _installer_service_backup

  TEST_OUTPUT="$(_fixture_get_expected_cron_content)"
  assert_snapshot "${RPI_INSTALLER_CRON_FILE_PATH}"
}

@parametrize_with_constants \
  test_install_installer_service_backup__@vary__creates_cron_file

# shellcheck disable=SC2034
test_install_installer_service_backup__@vary__configures_systemd_correctly() {
  local RPI_INSTALLER_CRON_FILE_PATH="${temp_folder}/cron_file"
  local RPI_INSTALLER_SYSTEMD_SERVICE_PATH="${temp_folder}/systemd_service"
  local RPI_INSTALLER_SYSTEMD_TIMER_PATH="${temp_folder}/systemd_timer"
  local RPI_SVC_GROUPNAME="${TEST_GROUPNAME}"
  local RPI_SVC_USERNAME="${TEST_USERNAME}"
  local RPI_ROOT="${TEST_ROOT}"
  local RPI_BACKUP_SCHEDULER_START_TIME="${TEST_SCHEDULER_START_TIME}"
  local RPI_BACKUP_SCHEDULING_HOUR="${TEST_SCHEDULING_HOUR}"

  _installer_service_backup

  systemctl.mock.assert_calls_are \
    "1(daemon-reload)" \
    "1(enable) 2(rpi-backup.timer)"
}

@parametrize_with_constants \
  test_install_installer_service_backup__@vary__configures_systemd_correctly

# shellcheck disable=SC2034
test_install_installer_service_backup__@vary__logs_success_message() {
  local RPI_INSTALLER_CRON_FILE_PATH="${temp_folder}/cron_file"
  local RPI_INSTALLER_SYSTEMD_SERVICE_PATH="${temp_folder}/systemd_service"
  local RPI_INSTALLER_SYSTEMD_TIMER_PATH="${temp_folder}/systemd_timer"
  local RPI_SVC_GROUPNAME="${TEST_GROUPNAME}"
  local RPI_SVC_USERNAME="${TEST_USERNAME}"
  local RPI_ROOT="${TEST_ROOT}"
  local RPI_BACKUP_SCHEDULER_START_TIME="${TEST_SCHEDULER_START_TIME}"
  local RPI_BACKUP_SCHEDULING_HOUR="${TEST_SCHEDULING_HOUR}"

  _installer_service_backup

  _cli_log_success.mock.assert_called_once_with \
    "1(INSTALLER: Service backup systemd service installed!)"
}

@parametrize_with_constants \
  test_install_installer_service_backup__@vary__logs_success_message
