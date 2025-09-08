#!/bin/bash

setup() {
  _mock.create ls
  _mock.create _cli_log_error
  _mock.create sleep
}

_fixture_setup_mocked_call_failures() {
  local side_effects=()

  stdlib.array.make.from_string side_effects "|" "${TEST_SIDE_EFFECT_DEFINITION}"
  stdlib.array.mutate.format "return %s" side_effects
  ls.mock.set.side_effects "${side_effects[@]}"
}

@parametrize_with_successes() {
  # $1: the test to parametrize

  @parametrize \
    "${1}" \
    "TEST_COMMAND_DEFINITION;TEST_SIDE_EFFECT_DEFINITION;TEST_ERROR_LOG_COUNT;TEST_EXPECTED_RC" \
    "3_attempts__2_failures__3_attempt_limit;3|ls -la;1|1|0;2;0" \
    "2_attempts__1_failure___4_attempt_limit;4|ls -la;1|0;1;0" \
    "1_attempts__0_failures__5_attempt_limit;5|ls -la;0;0;0"
}

@parametrize_with_failures() {
  # $1: the test to parametrize

  @parametrize \
    "${1}" \
    "TEST_COMMAND_DEFINITION;TEST_SIDE_EFFECT_DEFINITION;TEST_ERROR_LOG_COUNT;TEST_EXPECTED_RC" \
    "3_attempts__3_failures__3_attempt_limit;3|ls -la;1|1|1|?;3;127" \
    "2_attempts__2_failure___2_attempt_limit;2|ls -la;1|1|?;2;127" \
    "1_attempts__1_failures__1_attempt_limit;1|ls -la;1|?;1;127"
}

test_control_retries__@vary__@vary__returns_expected_status_code() {
  local command_args=()

  _fixture_setup_mocked_call_failures
  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_DEFINITION}"

  # shellcheck disable=SC2068
  _capture.rc _control_retries ${command_args[@]}

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize.apply \
  test_control_retries__@vary__@vary__returns_expected_status_code \
  @parametrize_with_successes \
  @parametrize_with_failures

test_control_retries__successes__@vary__logs_expected_error_messages() {
  local command_args=()
  local log_errors=()
  local error_index

  _fixture_setup_mocked_call_failures
  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_DEFINITION}"
  stdlib.array.make.from_string_n log_errors "${TEST_ERROR_LOG_COUNT}" "1(CONTROL: An error occurred, retrying in 1 second(s)...)"

  # shellcheck disable=SC2068
  _control_retries ${command_args[@]}

  _cli_log_error.mock.assert_calls_are "${log_errors[@]}"
}

@parametrize_with_successes \
  test_control_retries__successes__@vary__logs_expected_error_messages

test_control_retries__failures___@vary__logs_expected_error_messages() {
  local command_args=()
  local log_errors=()
  local error_index

  _fixture_setup_mocked_call_failures
  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_DEFINITION}"
  stdlib.array.make.from_string_n log_errors "${TEST_ERROR_LOG_COUNT}" "1(CONTROL: An error occurred, retrying in 1 second(s)...)"
  log_errors+=("1(CONTROL: This command has failed, despite retries.)")

  # shellcheck disable=SC2068
  _control_retries ${command_args[@]}

  _cli_log_error.mock.assert_calls_are "${log_errors[@]}"
}

@parametrize_with_failures \
  test_control_retries__failures___@vary__logs_expected_error_messages

test_control_retries__@vary__@vary__waits_for_backoff_time_after_each_failure() {
  local command_args=()
  local side_effects=()
  local side_effect_count=0

  stdlib.array.make.from_string side_effects "|" "${TEST_SIDE_EFFECT_DEFINITION}"
  _fixture_setup_mocked_call_failures
  stdlib.array.make.from_string command_args "|" "${TEST_COMMAND_DEFINITION}"

  # shellcheck disable=SC2068
  _control_retries ${command_args[@]}

  side_effect_count="$(("${#side_effects[@]}" - "1"))"
  sleep.mock.assert_count_is "${side_effect_count}"
  for ((error_index = 1; error_index <= "${side_effect_count}"; error_index++)); do
    sleep.mock.assert_call_n_is "${error_index}" \
      "1(1)"
  done
}

@parametrize.apply \
  test_control_retries__@vary__@vary__waits_for_backoff_time_after_each_failure \
  @parametrize_with_successes \
  @parametrize_with_failures
