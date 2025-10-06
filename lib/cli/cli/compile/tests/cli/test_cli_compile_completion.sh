#!/bin/bash

setup() {
  _mock.create _cli_compiler_build_completion
}

test_cli_compile_cli_completion__generates_the_correct_target() {
  _compile_cli_completion

  _cli_compiler_build_completion.mock.assert_called_once_with ""
}
