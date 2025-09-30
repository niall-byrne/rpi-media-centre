#!/bin/bash

setup() {
  _mock.create _cli_pretty_highlight
  _mock.create _cli_pretty_markdown_link_pipe
  _mock.create _cli_pretty_columns_pipe
  _mock.create grep

  _cli_pretty_markdown_link_pipe.mock.set.pipeable 1
  _cli_pretty_columns_pipe.mock.set.pipeable 1

  grep.mock.set.stdout "|B|grep output value b|
|C|grep output value c|
|D|grep output value d|
|A|grep output value a|
"
  # shellcheck disable=SC2016
  _cli_pretty_markdown_link_pipe.mock.set.subcommand 'echo "from_pretty_markdown:${1}"'
}

test_configuration_pictl_help__calls_highlight() {
  _configuration_pictl_help > /dev/null

  _cli_pretty_highlight.mock.assert_called_once_with \
    "1(The config file is a sourced BASH script that configures one or more of the following:)"
}

test_configuration_pictl_help__calls_grep_as_expected() {
  _configuration_pictl_help > /dev/null

  grep.mock.assert_called_once_with \
    "1(^| \`RPI_) 2(README.md)"
}

test_configuration_pictl_help__grep_output_is_passed_to_cli_pretty_markdown() {
  _configuration_pictl_help > /dev/null

  _cli_pretty_markdown_link_pipe.mock.assert_called_once_with "1(
A|grep output value a
B|grep output value b
C|grep output value c
D|grep output value d)"
}

test_configuration_pictl_help__pretty_markdown_is_piped_to_pretty_columns() {
  _configuration_pictl_help > /dev/null

  _cli_pretty_columns_pipe.mock.assert_called_once_with "1(from_pretty_markdown:
A|grep output value a
B|grep output value b
C|grep output value c
D|grep output value d)"
}

test_configuration_pictl_help__outputs_expected_info_message() {
  local RPI_PROJECT_REPOSITORY="https://some/url.com"

  _capture.output _configuration_pictl_help

  assert_output "Please see ${RPI_PROJECT_REPOSITORY} for further details."
}
