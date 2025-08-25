#!/bin/bash

test_stdlib_builtin_overridable__default_behaviour______________does_not_allow_override() {
  _mock.create echo

  stdlib.builtin.overridable echo "hello" > /dev/null

  echo.mock.assert_not_called

  _mock.delete echo
}

test_stdlib_builtin_overridable__environment_variable_set_to_1__allows_override() {
  _mock.create echo

  _STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN=1 \
    stdlib.builtin.overridable echo "hello" > /dev/null

  echo.mock.assert_called_once_with "1(hello)"

  _mock.delete echo
}

test_stdlib_builtin_overridable__environment_variable_set_to_0__does_not_allow_override() {
  _mock.create echo

  _STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN=0 \
    stdlib.builtin.overridable echo "hello" > /dev/null

  echo.mock.assert_not_called

  _mock.delete echo
}
