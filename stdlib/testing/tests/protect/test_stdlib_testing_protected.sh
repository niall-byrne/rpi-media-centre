#!/bin/bash

setup() {
  _mock.create _mock_stdlib.fn1
  _mock.create _mock_stdlib.testing.internal.fn1
  _mock_stdlib.testing.internal.fn1.mock.set.keywords _STDLIB_BUILTIN_BOOLEAN
}

test_stdlib_testing_protected__with_mocked_function__no_args__calls_protected_clone_correctly() {
  __testing.protected _mock_stdlib.fn1

  _mock_stdlib.testing.internal.fn1.mock.assert_called_once_with \
    "_STDLIB_BUILTIN_BOOLEAN(1)"
}

test_stdlib_testing_protected__with_mocked_function__args_____calls_protected_clone_correctly() {
  __testing.protected _mock_stdlib.fn1 arg1 arg2

  _mock_stdlib.testing.internal.fn1.mock.assert_called_once_with \
    "1(arg1) 2(arg2) _STDLIB_BUILTIN_BOOLEAN(1)"
}

test_stdlib_testing_protected__with_mocked_function__no_args__does_not_call_original() {
  __testing.protected _mock_stdlib.fn1

  _mock_stdlib.fn1.mock.assert_not_called
}

test_stdlib_testing_protected__with_mocked_function__args_____does_not_call_original() {
  __testing.protected _mock_stdlib.fn1 arg1 arg2

  _mock_stdlib.fn1.mock.assert_not_called
}
