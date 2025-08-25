#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args__________returns_status_code_127;;127" \
    "extra_arg________returns_status_code_127;A|extra_arg;127" \
    "empty_string_____returns_status_code_126;|;126" \
    "multiple_chars___returns_status_code___1;!2jfA0;1" \
    "symbol___________returns_status_code___0;@;0" \
    "alpha____________returns_status_code___0;A;0" \
    "numeric__________returns_status_code___0;3;0"
}

# shellcheck disable=SC2034
test_stdlib_string_query_is_char__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.query.is_char "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_query_is_char__@vary
