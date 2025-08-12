#!/bin/bash

test_mock_object__set.rc__@vary__returns_correct_value() {
  _mock.create test_mock
  test_mock.mock.set.rc "${EXPECTED_RC}"

  _capture_rc test_mock

  assert_equals "${EXPECTED_RC}" "${TEST_RC}"
}

@parametrize \
  "test_mock_object__set.rc__@vary__returns_correct_value" \
  "EXPECTED_RC" \
  "with_rc_9,9" \
  "with_rc_0,0"
