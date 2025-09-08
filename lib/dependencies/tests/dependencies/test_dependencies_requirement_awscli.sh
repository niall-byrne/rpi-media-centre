#!/bin/bash

setup() {
  _mock.create _dependencies_enforce
}

test_dependencies_requirement_awscli__enforce_is_called_with_correct_arguments() {
  _dependencies_requirement_awscli

  _dependencies_enforce.mock.assert_calls_are \
    "1(aws) 2(The aws cli) 3(Please see https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html for further details)"
}
