#!/bin/bash

test_cli_pretty_entity__arg__correct_output() {
  TEST_EXPECTED="${THEME_ENTITY}string${THEME_NC}"
  TEST_INPUT="string"

  _capture_output _cli_pretty_entity "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_cli_pretty_entity__pipe__correct_output() {
  TEST_EXPECTED="${THEME_ENTITY}string${THEME_NC}"
  TEST_INPUT="string"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | _cli_pretty_entity)"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
