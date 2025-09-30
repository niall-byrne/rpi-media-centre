#!/bin/bash

setup() {
  _mock.create curl
  _mock.create sleep

  curl.mock.set.rc 0
}

_curl_side_effect() {
  TEST_CURL_CALL_COUNT="$((TEST_CURL_CALL_COUNT + 1))"

  if [[ "${TEST_CURL_CALL_COUNT}" -lt 3 ]]; then
    return 1
  fi
  return 0
}

test_config_service_syncthing_setting__simulated_success__calls_curl_once_correctly() {
  _config_service_syncthing_healthcheck

  curl.mock.assert_called_once_with \
    "1(-fkLsS) 2(-m) 3(2) 4(127.0.0.1:8384/rest/noauth/health)"
}

test_config_service_syncthing_setting__simulated_success__does_not_call_sleep() {
  _config_service_syncthing_healthcheck

  sleep.mock.assert_not_called
}

test_config_service_syncthing_setting__simulated_failure__calls_curl_until_success() {
  local TEST_CURL_CALL_COUNT=0

  curl.mock.set.subcommand "_curl_side_effect"

  _config_service_syncthing_healthcheck

  curl.mock.assert_count_is 3
}

test_config_service_syncthing_setting__simulated_failure__calls_sleep_after_each_curl_call() {
  local TEST_CURL_CALL_COUNT=0

  curl.mock.set.subcommand "_curl_side_effect"

  _config_service_syncthing_healthcheck

  sleep.mock.assert_calls_are \
    "1(1)" \
    "1(1)"
}
