#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/testing/assertion/tests/capture.sh"

# shellcheck disable=SC2034
setup() {
  keyword1="value1"
  keyword2="value2"
}

test_stdlib_testing_mock_object_assert_calls_are__not_called___single_call_____no_keywords____matching__succeeds() {
  _mock.create test_mock

  test_mock.mock.assert_calls_are
}

test_stdlib_testing_mock_object_assert_calls_are__not_called___single_call_____with_keywords__matching__succeeds() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"

  test_mock.mock.assert_calls_are
}

test_stdlib_testing_mock_object_assert_calls_are__not_called___single_call_____no_keywords____index_0___fails() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    "1(call 1; call1"$'\n'"call1 call1 \'\";)"
  )

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_output "$(_testing.mock.message.get "MOCK_NOT_CALLED" "test_mock")"
}

test_stdlib_testing_mock_object_assert_calls_are__not_called___single_call_____with_keywords__index_0___fails() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  EXPECTED_CALLS=(
    "1(call 1; call1"$'\n'"call1 call1 \'\";)"
  )

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_output "$(_testing.mock.message.get "MOCK_NOT_CALLED" "test_mock")"
}

test_stdlib_testing_mock_object_assert_calls_are__no_args______single_call_____no_keywords____matching__succeeds() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    ""
  )

  test_mock

  test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"
}

test_stdlib_testing_mock_object_assert_calls_are__no_args______single_call_____with_keywords__matching__succeeds() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  EXPECTED_CALLS=(
    "keyword1(value1) keyword2(value2)"
  )

  test_mock

  test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"
}

test_stdlib_testing_mock_object_assert_calls_are__no_args______single_call_____no_keywords____index_0___fails() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    "1(arg1)"
  )

  test_mock

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_output \
    "$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "test_mock" "1")
 expected [1\(arg1\)] but was ['']"
}

test_stdlib_testing_mock_object_assert_calls_are__no_args______single_call_____with_keywords__index_0___fails() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  EXPECTED_CALLS=(
    "1(arg1) keyword1(value1) keyword2(value2)"
  )

  test_mock

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_output \
    "$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "test_mock" "1")
 expected [1\(arg1\)\ keyword1\(value1\)\ keyword2\(value2\)] but was [keyword1\(value1\)\ keyword2\(value2\)]"
}

test_stdlib_testing_mock_object_assert_calls_are__no_args______multiple_calls__no_keywords____matching__succeeds() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    ""
    ""
    ""
  )

  test_mock
  test_mock
  test_mock

  test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"
}

test_stdlib_testing_mock_object_assert_calls_are__no_args______multiple_calls__with_keywords__matching__succeeds() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  EXPECTED_CALLS=(
    "keyword1(value1) keyword2(value2)"
    "keyword1(value1) keyword2(value2)"
    "keyword1(value1) keyword2(value2)"
  )

  test_mock
  test_mock
  test_mock

  test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"
}

test_stdlib_testing_mock_object_assert_calls_are__no_args______multiple_calls__no_keywords____index_1___fails() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    ""
    "1(arg1)"
    ""
  )

  test_mock
  test_mock
  test_mock

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_output \
    "$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "test_mock" "2")
 expected [1\(arg1\)] but was ['']"
}

test_stdlib_testing_mock_object_assert_calls_are__no_args______multiple_calls__with_keywords__index_1___fails() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  EXPECTED_CALLS=(
    "keyword1(value1) keyword2(value2)"
    "1(arg1) keyword1(value1) keyword2(value2)"
    "keyword1(value1) keyword2(value2)"
  )

  test_mock
  test_mock
  test_mock

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_output \
    "$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "test_mock" "2")
 expected [1\(arg1\)\ keyword1\(value1\)\ keyword2\(value2\)] but was [keyword1\(value1\)\ keyword2\(value2\)]"
}

test_stdlib_testing_mock_object_assert_calls_are__single_arg___single_call_____no_keywords____matching__succeeds() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    "1(call 1; call1"$'\n'"call1 call1 \'\";)"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";"

  test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"
}

test_stdlib_testing_mock_object_assert_calls_are__single_arg___single_call_____with_keywords__matching__succeeds() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  EXPECTED_CALLS=(
    "1(call 1; call1"$'\n'"call1 call1 \'\";) keyword1(value1) keyword2(value2)"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";"

  test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"
}

test_stdlib_testing_mock_object_assert_calls_are__single_arg___single_call_____no_keywords____index_0___fails() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    "1(arg1)"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";"

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_output \
    "$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "test_mock" "1")
 expected [1\(arg1\)] but was [$'1(call 1; call1
call1 call1 \\'\";)']"
}

test_stdlib_testing_mock_object_assert_calls_are__single_arg___single_call_____with_keywords__index_0___fails() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  EXPECTED_CALLS=(
    "1(arg1) keyword1(value1) keyword2(value2)"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";"

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_output \
    "$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "test_mock" "1")
 expected [1\(arg1\)\ keyword1\(value1\)\ keyword2\(value2\)] but was [$'1(call 1; call1
call1 call1 \\'\";) keyword1(value1) keyword2(value2)']"
}

test_stdlib_testing_mock_object_assert_calls_are__single_arg___single_call_____no_keywords____extra_____fails() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  EXPECTED_CALLS=(
    "1(arg1) keyword1(value1) keyword2(value2)"
    "extra call"
  )

  test_mock "arg1"

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_output \
    "$(_testing.mock.message.get MOCK_CALLED_N_TIMES "test_mock" "1")"
}

test_stdlib_testing_mock_object_assert_calls_are__single_arg___single_call_____with_keywords__extra_____fails() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    "1(arg1)"
    "extra call"
  )

  test_mock "arg1"

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_output \
    "$(_testing.mock.message.get MOCK_CALLED_N_TIMES "test_mock" "1")"
}

test_stdlib_testing_mock_object_assert_calls_are__single_arg___multiple_calls__no_keywords____matching__succeeds() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    "1(call 1; call1"$'\n'"call1 call1 \'\";)"
    "1(call 2; call2"$'\n'"call2 call2 \'\";)"
    "1(call 3; call3"$'\n'"call3 call3 \'\";)"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";"
  test_mock "call 2; call2"$'\n'"call2 call2 \'\";"
  test_mock "call 3; call3"$'\n'"call3 call3 \'\";"

  test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"
}

test_stdlib_testing_mock_object_assert_calls_are__single_arg___multiple_calls__with_keywords__matching__succeeds() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  EXPECTED_CALLS=(
    "1(call 1; call1"$'\n'"call1 call1 \'\";) keyword1(value1) keyword2(value2)"
    "1(call 2; call2"$'\n'"call2 call2 \'\";) keyword1(value1) keyword2(value2)"
    "1(call 3; call3"$'\n'"call3 call3 \'\";) keyword1(value1) keyword2(value2)"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";"
  test_mock "call 2; call2"$'\n'"call2 call2 \'\";"
  test_mock "call 3; call3"$'\n'"call3 call3 \'\";"

  test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"
}

test_stdlib_testing_mock_object_assert_calls_are__single_arg___multiple_calls__no_keywords____index_2___fails() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    "1(call 1; call1"$'\n'"call1 call1 \'\";)"
    "1(call 2; call2"$'\n'"call2 call2 \'\";)"
    "1(call 3; call3"$'\n'"call3 call3 \'\"; - does not match)"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";"
  test_mock "call 2; call2"$'\n'"call2 call2 \'\";"
  test_mock "call 3; call3"$'\n'"call3 call3 \'\";"

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_output \
    "$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "test_mock" "3")
 expected [$'1(call 3; call3
call3 call3 \\'\"; - does not match)'] but was [$'1(call 3; call3
call3 call3 \\'\";)']"
}

test_stdlib_testing_mock_object_assert_calls_are__single_arg___multiple_calls__with_keywords__index_2___fails() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  EXPECTED_CALLS=(
    "1(call 1; call1"$'\n'"call1 call1 \'\";) keyword1(value1) keyword2(value2)"
    "1(call 2; call2"$'\n'"call2 call2 \'\";) keyword1(value1) keyword2(value2)"
    "1(call 3; call3"$'\n'"call3 call3 \'\"; - does not match) keyword1(value1) keyword2(value2)"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";"
  test_mock "call 2; call2"$'\n'"call2 call2 \'\";"
  test_mock "call 3; call3"$'\n'"call3 call3 \'\";"

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_output \
    "$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "test_mock" "3")
 expected [$'1(call 3; call3
call3 call3 \\'\"; - does not match) keyword1(value1) keyword2(value2)'] but was [$'1(call 3; call3
call3 call3 \\'\";) keyword1(value1) keyword2(value2)']"
}

test_stdlib_testing_mock_object_assert_calls_are__single_arg___multiple_calls__no_keywords____extra___fails() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    "1(call 1; call1"$'\n'"call1 call1 \'\";)"
    "1(call 2; call2"$'\n'"call2 call2 \'\";)"
    "1(call 3; call3"$'\n'"call3 call3 \'\";)"
    "extra call"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";"
  test_mock "call 2; call2"$'\n'"call2 call2 \'\";"
  test_mock "call 3; call3"$'\n'"call3 call3 \'\";"

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_output \
    "$(_testing.mock.message.get MOCK_CALLED_N_TIMES "test_mock" "3")"
}

test_stdlib_testing_mock_object_assert_calls_are__single_arg___multiple_calls__with_keywords__extra___fails() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  EXPECTED_CALLS=(
    "1(call 1; call1"$'\n'"call1 call1 \'\";) keyword1(value1) keyword2(value2)"
    "1(call 2; call2"$'\n'"call2 call2 \'\";) keyword1(value1) keyword2(value2)"
    "1(call 3; call3"$'\n'"call3 call3 \'\";) keyword1(value1) keyword2(value2)"
    "extra call"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";"
  test_mock "call 2; call2"$'\n'"call2 call2 \'\";"
  test_mock "call 3; call3"$'\n'"call3 call3 \'\";"

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_output \
    "$(_testing.mock.message.get MOCK_CALLED_N_TIMES "test_mock" "3")"
}

test_stdlib_testing_mock_object_assert_calls_are__double_args__multiple_calls__no_keywords____matching__succeeds() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    "1(call 1; call1"$'\n'"call1 call1 \'\";) 2(call1arg2)"
    "1(call 2; call2"$'\n'"call2 call2 \'\";) 2(call2arg2)"
    "1(call 3; call3"$'\n'"call3 call3 \'\";) 2(call3arg2)"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";" "call1arg2"
  test_mock "call 2; call2"$'\n'"call2 call2 \'\";" "call2arg2"
  test_mock "call 3; call3"$'\n'"call3 call3 \'\";" "call3arg2"

  test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"
}

test_stdlib_testing_mock_object_assert_calls_are__double_args__multiple_calls__with_keywords__matching__succeeds() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  EXPECTED_CALLS=(
    "1(call 1; call1"$'\n'"call1 call1 \'\";) 2(call1arg2) keyword1(value1) keyword2(value2)"
    "1(call 2; call2"$'\n'"call2 call2 \'\";) 2(call2arg2) keyword1(value1) keyword2(value2)"
    "1(call 3; call3"$'\n'"call3 call3 \'\";) 2(call3arg2) keyword1(value1) keyword2(value2)"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";" "call1arg2"
  test_mock "call 2; call2"$'\n'"call2 call2 \'\";" "call2arg2"
  test_mock "call 3; call3"$'\n'"call3 call3 \'\";" "call3arg2"

  test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"
}

test_stdlib_testing_mock_object_assert_calls_are__double_args__single_call_____no_keywords____index_0___fails() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    "1(call 1; call1"$'\n'"call1 call1 \'\";) 2(call1arg2 - does not match)"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";" "call1arg2"

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_output \
    "$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "test_mock" "1")
 expected [$'1(call 1; call1
call1 call1 \\'\";) 2(call1arg2 - does not match)'] but was [$'1(call 1; call1
call1 call1 \\'\";) 2(call1arg2)']"
}

test_stdlib_testing_mock_object_assert_calls_are__double_args__single_call_____with_keywords__index_0___fails() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  EXPECTED_CALLS=(
    "1(call 1; call1"$'\n'"call1 call1 \'\";) 2(call1arg2 - does not match) keyword1(value1) keyword2(value2)"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";" "call1arg2"

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_output \
    "$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "test_mock" "1")
 expected [$'1(call 1; call1
call1 call1 \\'\";) 2(call1arg2 - does not match) keyword1(value1) keyword2(value2)'] but was [$'1(call 1; call1
call1 call1 \\'\";) 2(call1arg2) keyword1(value1) keyword2(value2)']"
}

test_stdlib_testing_mock_object_assert_calls_are__double_args__multiple_calls__no_keywords____index_0___fails() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    "1(call 1; call1"$'\n'"call1 call1 \'\";) 2(call1arg2 - does not match)"
    "1(call 2; call2"$'\n'"call2 call2 \'\";) 2(call2arg2)"
    "1(call 3; call3"$'\n'"call3 call3 \'\";) 2(call3arg2)"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";" "call1arg2"
  test_mock "call 2; call2"$'\n'"call2 call2 \'\";" "call2arg2"
  test_mock "call 3; call3"$'\n'"call3 call3 \'\";" "call3arg2"

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_output \
    "$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "test_mock" "1")
 expected [$'1(call 1; call1
call1 call1 \\'\";) 2(call1arg2 - does not match)'] but was [$'1(call 1; call1
call1 call1 \\'\";) 2(call1arg2)']"
}

test_stdlib_testing_mock_object_assert_calls_are__double_args__multiple_calls__with_keywords__index_0___fails() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  EXPECTED_CALLS=(
    "1(call 1; call1"$'\n'"call1 call1 \'\";) 2(call1arg2 - does not match) keyword1(value1) keyword2(value2)"
    "1(call 2; call2"$'\n'"call2 call2 \'\";) 2(call2arg2) keyword1(value1) keyword2(value2)"
    "1(call 3; call3"$'\n'"call3 call3 \'\";) 2(call3arg2) keyword1(value1) keyword2(value2)"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";" "call1arg2"
  test_mock "call 2; call2"$'\n'"call2 call2 \'\";" "call2arg2"
  test_mock "call 3; call3"$'\n'"call3 call3 \'\";" "call3arg2"

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_output \
    "$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "test_mock" "1")
 expected [$'1(call 1; call1
call1 call1 \\'\";) 2(call1arg2 - does not match) keyword1(value1) keyword2(value2)'] but was [$'1(call 1; call1
call1 call1 \\'\";) 2(call1arg2) keyword1(value1) keyword2(value2)']"
}

test_stdlib_testing_mock_object_assert_calls_are__double_args__multiple_calls__no_keywords____index_1___fails() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    "1(call 1; call1"$'\n'"call1 call1 \'\";) 2(call1arg2)"
    "1(call 2; call2"$'\n'"call2 call2 \'\";) 2(call2arg2 - does not match)"
    "1(call 3; call3"$'\n'"call3 call3 \'\";) 2(call3arg2)"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";" "call1arg2"
  test_mock "call 2; call2"$'\n'"call2 call2 \'\";" "call2arg2"
  test_mock "call 3; call3"$'\n'"call3 call3 \'\";" "call3arg2"

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_output \
    "$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "test_mock" "2")
 expected [$'1(call 2; call2
call2 call2 \\'\";) 2(call2arg2 - does not match)'] but was [$'1(call 2; call2
call2 call2 \\'\";) 2(call2arg2)']"
}

test_stdlib_testing_mock_object_assert_calls_are__double_args__multiple_calls__with_keywords__index_1___fails() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  EXPECTED_CALLS=(
    "1(call 1; call1"$'\n'"call1 call1 \'\";) 2(call1arg2) keyword1(value1) keyword2(value2)"
    "1(call 2; call2"$'\n'"call2 call2 \'\";) 2(call2arg2 - does not match) keyword1(value1) keyword2(value2)"
    "1(call 3; call3"$'\n'"call3 call3 \'\";) 2(call3arg2) keyword1(value1) keyword2(value2)"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";" "call1arg2"
  test_mock "call 2; call2"$'\n'"call2 call2 \'\";" "call2arg2"
  test_mock "call 3; call3"$'\n'"call3 call3 \'\";" "call3arg2"

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_output \
    "$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "test_mock" "2")
 expected [$'1(call 2; call2
call2 call2 \\'\";) 2(call2arg2 - does not match) keyword1(value1) keyword2(value2)'] but was [$'1(call 2; call2
call2 call2 \\'\";) 2(call2arg2) keyword1(value1) keyword2(value2)']"
}

test_stdlib_testing_mock_object_assert_calls_are__double_args__multiple_calls__no_keywords____index_2___fails() {
  _mock.create test_mock
  EXPECTED_CALLS=(
    "1(call 1; call1"$'\n'"call1 call1 \'\";) 2(call1arg2)"
    "1(call 2; call2"$'\n'"call2 call2 \'\";) 2(call2arg2)"
    "1(call 3; call3"$'\n'"call3 call3 \'\";) 2(call3arg2 - does not match)"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";" "call1arg2"
  test_mock "call 2; call2"$'\n'"call2 call2 \'\";" "call2arg2"
  test_mock "call 3; call3"$'\n'"call3 call3 \'\";" "call3arg2"

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_output \
    "$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "test_mock" "3")
 expected [$'1(call 3; call3
call3 call3 \\'\";) 2(call3arg2 - does not match)'] but was [$'1(call 3; call3
call3 call3 \\'\";) 2(call3arg2)']"
}

test_stdlib_testing_mock_object_assert_calls_are__double_args__multiple_calls__with_keywords__index_2___fails() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  EXPECTED_CALLS=(
    "1(call 1; call1"$'\n'"call1 call1 \'\";) 2(call1arg2) keyword1(value1) keyword2(value2)"
    "1(call 2; call2"$'\n'"call2 call2 \'\";) 2(call2arg2) keyword1(value1) keyword2(value2)"
    "1(call 3; call3"$'\n'"call3 call3 \'\";) 2(call3arg2 - does not match) keyword1(value1) keyword2(value2)"
  )

  test_mock "call 1; call1"$'\n'"call1 call1 \'\";" "call1arg2"
  test_mock "call 2; call2"$'\n'"call2 call2 \'\";" "call2arg2"
  test_mock "call 3; call3"$'\n'"call3 call3 \'\";" "call3arg2"

  _capture_assertion_failure test_mock.mock.assert_calls_are "${EXPECTED_CALLS[@]}"

  assert_output \
    "$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "test_mock" "3")
 expected [$'1(call 3; call3
call3 call3 \\'\";) 2(call3arg2 - does not match) keyword1(value1) keyword2(value2)'] but was [$'1(call 3; call3
call3 call3 \\'\";) 2(call3arg2) keyword1(value1) keyword2(value2)']"
}
