#!/bin/bash

setup() {
  _mock.create _cli_compiler_build_cli
}

test_cli_compile_cli_cli__generates_the_correct_target() {
  _compile_cli_cli

  _cli_compiler_build_cli.mock.assert_called_once_with \
    "1(1)"
}
