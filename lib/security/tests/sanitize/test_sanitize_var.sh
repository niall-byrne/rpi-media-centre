#!/bin/bash

test_security_sanitize_var__hidden_delete_commands() {
  TEST_EXPECTED="stringrm-rfddif=devzeroof=devsd0-9"
  TEST_INPUT="string rm -rf /; dd if=/dev/zero of=/dev/sd[0-9]"

  _security_sanitize_var "TEST_INPUT"

  assert_equals "${TEST_EXPECTED}" "${TEST_INPUT}"
}

test_security_sanitize_var__hidden_subshell() {
  TEST_EXPECTED="stringcpsecretfolder"
  TEST_INPUT="string (cp * /secret/folder)"

  _security_sanitize_var "TEST_INPUT"

  assert_equals "${TEST_EXPECTED}" "${TEST_INPUT}"
}
