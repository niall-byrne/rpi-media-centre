#!/bin/bash

# shellcheck disable=SC2034
setup() {
  TEST_ARRAY=()
  NOT_AN_ARRAY="not an array"
  _STDLIB_BINARY_RM="rm"

  _mock.create stdlib.logger.error
  _mock.create rm
}

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args__________________returns_status_code_127;;127" \
    "fn_name_is_null__________returns_status_code_126;|NOT_AN_ARRAY;126" \
    "array_is_invalid_________returns_status_code_126;clean_up_fn|NOT_AN_ARRAY;126" \
    "boolean_is_invalid_______returns_status_code_126;clean_up_fn|TEST_ARRAY|a;126" \
    "valid_args_with_boolean__returns_status_code___0;clean_up_fn|TEST_ARRAY|1;0" \
    "valid_args_not_boolean___returns_status_code___0;clean_up_fn|TEST_ARRAY;0"
}

@parametrize_with_clean_up_fn_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "valid_args__returns_status_code___0;;0" \
    "extra_arg___returns_status_code_127;extra_arg;127"
}

test_stdlib_trap_create_clean_up_fn__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.trap.create.clean_up_fn "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_trap_create_clean_up_fn__@vary

test_stdlib_trap_create_clean_up_fn__valid_args_______________creates_clean_up_fn() {
  stdlib.trap.create.clean_up_fn clean_up_fn TEST_ARRAY

  assert_is_fn clean_up_fn
}

test_stdlib_trap_create_clean_up_fn__valid_args_______________clean_up_fn_function__@vary() {
  local args=()
  stdlib.trap.create.clean_up_fn clean_up_fn TEST_ARRAY

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc clean_up_fn "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_clean_up_fn_arg_combos \
  test_stdlib_trap_create_clean_up_fn__valid_args_______________clean_up_fn_function__@vary

# shellcheck disable=SC2034
test_stdlib_trap_create_clean_up_fn__valid_args_______________clean_up_fn_function__valid_args__default_behaviour________all_files_exist___calls_non_recursive_rm_on_each_existing_file() {
  _mock.create test
  test.mock.set.rc 0

  stdlib.trap.create.clean_up_fn clean_up_fn TEST_ARRAY
  TEST_ARRAY+=("file_exists_1")
  TEST_ARRAY+=("file_exists_2")
  TEST_ARRAY+=("file_exists_3")

  clean_up_fn

  rm.mock.assert_calls_are \
    "1(-f) 2(file_exists_1)" \
    "1(-f) 2(file_exists_2)" \
    "1(-f) 2(file_exists_3)"
}

# shellcheck disable=SC2034
test_stdlib_trap_create_clean_up_fn__valid_args_______________clean_up_fn_function__valid_args__default_behaviour________some_files_exist__calls_non_recursive_rm_on_each_existing_file() {
  _mock.create test
  test.mock.set.side_effects "return 0" "return 1" "return 0"

  stdlib.trap.create.clean_up_fn clean_up_fn TEST_ARRAY
  TEST_ARRAY+=("file_exists_1")
  TEST_ARRAY+=("file_does_not_exists")
  TEST_ARRAY+=("file_exists_3")

  clean_up_fn

  rm.mock.assert_calls_are \
    "1(-f) 2(file_exists_1)" \
    "1(-f) 2(file_exists_3)"
}

# shellcheck disable=SC2034
test_stdlib_trap_create_clean_up_fn__valid_args_______________clean_up_fn_function__valid_args__specified_non_recursive__all_files_exist___calls_non_recursive_rm_on_each_existing_file() {
  _mock.create test
  test.mock.set.rc 0

  stdlib.trap.create.clean_up_fn clean_up_fn TEST_ARRAY "0"
  TEST_ARRAY+=("file_exists_1")
  TEST_ARRAY+=("file_exists_2")
  TEST_ARRAY+=("file_exists_3")

  clean_up_fn

  rm.mock.assert_calls_are \
    "1(-f) 2(file_exists_1)" \
    "1(-f) 2(file_exists_2)" \
    "1(-f) 2(file_exists_3)"
}

# shellcheck disable=SC2034
test_stdlib_trap_create_clean_up_fn__valid_args_______________clean_up_fn_function__valid_args__specified_non_recursive__some_files_exist__calls_non_recursive_rm_on_each_existing_file() {
  _mock.create test
  test.mock.set.side_effects "return 0" "return 1" "return 0"

  stdlib.trap.create.clean_up_fn clean_up_fn TEST_ARRAY "0"
  TEST_ARRAY+=("file_exists_1")
  TEST_ARRAY+=("file_does_not_exists")
  TEST_ARRAY+=("file_exists_3")

  clean_up_fn

  rm.mock.assert_calls_are \
    "1(-f) 2(file_exists_1)" \
    "1(-f) 2(file_exists_3)"
}

# shellcheck disable=SC2034
test_stdlib_trap_create_clean_up_fn__valid_args_______________clean_up_fn_function__valid_args__specified_recursive______all_files_exist___calls_non_recursive_rm_on_each_existing_file() {
  _mock.create test
  test.mock.set.rc 0

  stdlib.trap.create.clean_up_fn clean_up_fn TEST_ARRAY "1"
  TEST_ARRAY+=("file_exists_1")
  TEST_ARRAY+=("file_exists_2")
  TEST_ARRAY+=("file_exists_3")

  clean_up_fn

  rm.mock.assert_calls_are \
    "1(-fr) 2(file_exists_1)" \
    "1(-fr) 2(file_exists_2)" \
    "1(-fr) 2(file_exists_3)"
}

# shellcheck disable=SC2034
test_stdlib_trap_create_clean_up_fn__valid_args_______________clean_up_fn_function__valid_args__specified_recursive______some_files_exist__calls_non_recursive_rm_on_each_existing_file() {
  _mock.create test
  test.mock.set.side_effects "return 0" "return 1" "return 0"

  stdlib.trap.create.clean_up_fn clean_up_fn TEST_ARRAY "1"
  TEST_ARRAY+=("file_exists_1")
  TEST_ARRAY+=("file_does_not_exists")
  TEST_ARRAY+=("file_exists_3")

  clean_up_fn

  rm.mock.assert_calls_are \
    "1(-fr) 2(file_exists_1)" \
    "1(-fr) 2(file_exists_3)"
}
