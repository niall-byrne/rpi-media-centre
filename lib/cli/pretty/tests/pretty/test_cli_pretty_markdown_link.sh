#!/bin/bash

test_cli_pretty_markdown_link__single_link__arg__correct_output() {
  TEST_EXPECTED="string string link string"
  TEST_INPUT="string string [link](https://some/site.com) string"

  _capture.output _cli_pretty_markdown_link "${TEST_INPUT}"

  assert_output "${TEST_EXPECTED}"
}

test_cli_pretty_markdown_link__single_link__pipe__correct_output() {
  TEST_EXPECTED="string string link string"
  TEST_INPUT="string string [link](https://some/site.com) string"

  TEST_OUTPUT="$(echo "${TEST_INPUT}" | _cli_pretty_markdown_link_pipe)"

  assert_equals "${TEST_EXPECTED}" "${TEST_OUTPUT}"
}
