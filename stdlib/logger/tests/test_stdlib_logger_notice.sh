#!/bin/bash

# shellcheck disable=SC2034
setup_suite() {
  expected_colour="$(stdlib.setting.theme.get_colour "${STDLIB_THEME_LOGGER_NOTICE}")"
}

test_stdlib_logger_notice__default_prefix____correct_stdout() {
  TEST_EXPECTED="${FUNCNAME[0]}: ${!expected_colour}test string${STDLIB_COLOUR_NC}"$'\n'
  TEST_INPUT="test string"

  _capture.stdout_raw stdlib.logger.notice "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_stdlib_logger_notice__specified_prefix__correct_stdout() {
  TEST_EXPECTED="specified prefix: ${!expected_colour}test string${STDLIB_COLOUR_NC}"$'\n'
  TEST_INPUT="test string"

  _STDLIB_LOGGING_MESSAGE_PREFIX="specified prefix" \
    _capture.stdout_raw stdlib.logger.notice "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_stdlib_logger_notice__decorator_prefix__correct_stdout() {
  local _STDLIB_LOGGING_DECORATORS=("${FUNCNAME[0]}")

  TEST_EXPECTED="${FUNCNAME[1]}: ${!expected_colour}test string${STDLIB_COLOUR_NC}"$'\n'
  TEST_INPUT="test string"

  _capture.stdout_raw stdlib.logger.notice "${TEST_INPUT}"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
