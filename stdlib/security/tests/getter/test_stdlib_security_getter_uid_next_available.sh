#!/bin/bash

setup() {
  _mock.create id
  _mock.create cat

  cat.mock.set.stdout "pi1:x:501:
pi2:x:2001:
pi1:x:501:501::/home/pi1:/bin/bash
pi2:x:2001:2001::/home/pi2:/bin/bash
"
}

@parameterize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "extra_arg___returns_status_code_127;extra_arg;127"
}

test_security_get_unused_uid__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.security.get.unused_uid "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parameterize_with_arg_combos \
  test_security_get_unused_uid__@vary

test_security_get_unused_uid__valid_args__no_existing_1000_series__emits_1000() {
  id.mock.set.subcommand "if (( \${current_id} < 1000 )); then return 0; else current_id=1000; return 1; fi"

  _capture.stdout stdlib.security.get.unused_uid

  assert_output "1000"
}

test_security_get_unused_uid__valid_args__no_existing_1000_series__returns_status_code_0() {
  id.mock.set.subcommand "if (( \${current_id} < 1000 )); then return 0; else current_id=1000; return 1; fi"

  _capture.rc stdlib.security.get.unused_uid > /dev/null

  assert_rc "0"
}

test_security_get_unused_uid__valid_args__existing_1000_series_____emits_next_sequential() {
  id.mock.set.subcommand "if (( \${current_id} < 1502 )); then return 0; else return 1; fi"

  _capture.stdout stdlib.security.get.unused_uid

  assert_output "1502"
}

test_security_get_unused_uid__valid_args__existing_1000_series_____returns_status_code_0() {
  id.mock.set.subcommand "if (( \${current_id} < 1502 )); then return 0; else return 1; fi"

  _capture.rc stdlib.security.get.unused_uid > /dev/null

  assert_rc "0"
}

test_security_get_unused_uid__valid_args__no_free_1000_series______emits_next_sequential() {
  id.mock.set.subcommand "if (( \${current_id} < 2001 )); then return 0; else return 1; fi"

  _capture.stdout stdlib.security.get.unused_uid

  assert_output "2002"
}

test_security_get_unused_uid__valid_args__no_free_1000_series______returns_status_code_0() {
  id.mock.set.subcommand "if (( \${current_id} < 2001 )); then return 0; else return 1; fi"

  _capture.rc stdlib.security.get.unused_uid > /dev/null

  assert_rc "0"
}

test_security_get_unused_uid__valid_args__no_free_ids______________return_1() {
  id.mock.set.subcommand "current_id=65536; return 0"

  _capture.rc stdlib.security.get.unused_uid

  assert_rc "1"
}
