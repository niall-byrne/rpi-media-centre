#!/bin/bash

setup() {
  _mock.create _cli_log_error
  _mock.create exit
}

test_debug_error_handler__logs_correct_output() {
  _debug_error_handler

  _cli_log_error.mock.assert_called_once_with \
    "1(ERROR source file: ./test_debug_error_handler.sh -- line: 9 -- command: local COMMAND=\"\${BASH_COMMAND}\" -- exit code: 0)"
}

test_debug_error_handler__exit_code_0__calls_exit_with_expected_status_code() {
  _debug_error_handler

  exit.mock.assert_called_once_with "1(0)"
}
