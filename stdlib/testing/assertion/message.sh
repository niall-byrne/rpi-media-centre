#!/bin/bash

# stdlib messages library

builtin set -eo pipefail

_testing.assert.message.get() {
  # $1: the message key to retrieve
  # $2: interpolation option 1
  # $3: interpolation option 2
  # $4: interpolation option 3

  local key="${1}"
  local message
  local option1="${2}"
  local option2="${3}"
  local required_options=0
  local return_status=0

  case "${key}" in
    ASSERT_ERROR_DID_NOT_FAIL)
      required_options=1
      message="The assertion '${option1}' was expected to fail, but it succeeded instead."
      ;;
    ASSERT_ERROR_FILE_NOT_FOUND)
      required_options=1
      message="the file '${option1}' does not exist"
      ;;
    ASSERT_ERROR_OUTPUT_NON_MATCHING)
      required_options=0
      message="the expected output string was not generated"
      ;;
    ASSERT_ERROR_OUTPUT_NULL)
      required_options=0
      message="the 'TEST_OUTPUT' value is empty, consider using '_capture.output'"
      ;;
    ASSERT_ERROR_RC_NON_MATCHING)
      required_options=0
      message="the expected status code was not returned"
      ;;
    ASSERT_ERROR_RC_NULL)
      required_options=0
      message="the 'TEST_RC' value is empty, consider using '_capture.rc'"
      ;;
    ASSERT_ERROR_SNAPSHOT_NON_MATCHING)
      required_options=1
      message="the contents of '${option1}' does not match the received output"
      ;;
    ASSERT_ERROR_VALUE_NOT_NULL)
      required_options=1
      message="The value '${option1}' is not null!"
      ;;
    ASSERT_ERROR_VALUE_NULL)
      required_options=0
      message="The value is null!"
      ;;
    ASSERT_ERROR_INSUFFICIENT_ARGS)
      required_options=1
      message="'${option1}' was not given sufficient arguments"
      ;;
    ASSERT_ERROR_ARRAY_LENGTH_NON_MATCHING)
      required_options=2
      message="expected [${option1}] but was [${option2}]"
      ;;
    "")
      required_options=0
      return_status=126
      message="$(__testing.protected stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      required_options=0
      return_status=126
      message="Unknown message key '${key}'"
      ;;
  esac

  (("${#@}" == 1 + required_options)) || {
    message="$(__testing.protected stdlib.message.get ARGUMENTS_INVALID)"
    return_status=127
  }

  ((return_status == 0)) || {
    __testing.protected stdlib.logger.error "${message}"
    return ${return_status}
  }

  builtin echo -n "${message}"
}
