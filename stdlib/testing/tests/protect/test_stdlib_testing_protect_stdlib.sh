#!/bin/bash

_mock_stdlib.fn1() {
  echo "original 1"
}

_mock_stdlib.fn2() {
  _mock_stdlib.fn1
}

test_stdlib_testing_protect_stdlib__creates_new_internal_functions() {
  _STDLIB_TESTING_STDLIB_PROTECT_PREFIX="_mock_stdlib" \
    __testing.protect_stdlib

  assert_is_fn _mock_stdlib.testing.internal.fn1
  assert_is_fn _mock_stdlib.testing.internal.fn1
}

test_stdlib_testing_protect_stdlib__preserves_implementation() {
  _STDLIB_TESTING_STDLIB_PROTECT_PREFIX="_mock_stdlib" \
    __testing.protect_stdlib

  _capture.stdout _mock_stdlib.testing.internal.fn1

  assert_output "original 1"
}

test_stdlib_testing_protect_stdlib__references_protected_functions() {
  _STDLIB_TESTING_STDLIB_PROTECT_PREFIX="_mock_stdlib" \
    __testing.protect_stdlib

  _mock.create _mock_stdlib.testing.internal.fn1

  _mock_stdlib.testing.internal.fn2

  _mock_stdlib.testing.internal.fn1.mock.assert_called_once_with ""
}
