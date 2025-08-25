#!/bin/bash

test_parametrize_components_debug__generates_log_message_for_eval() {
  _capture.stdout @parametrize._components.debug.message "debug message"

  assert_output "builtin echo 'debug message'"
}
