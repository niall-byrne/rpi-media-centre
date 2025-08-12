#!/bin/bash

# pictl extensions to bash_unit assertions

set -eo pipefail

__assertion_value_check() {
  # $1: the variable to check

  local VALUE_NAME="${1}"
  local ASSERTION_NAME="${FUNCNAME[1]}"

  if [[ -z "${VALUE_NAME}" ]]; then
    fail " '${ASSERTION_NAME}' was not given sufficient arguments"
  fi
}

assert_array_equals() {
  # $1: the first array to compare
  # $2: the second array to compare

  local INDIRECT_REFERENCE_1
  local INDIRECT_ARRAY_1=()
  local INDIRECT_REFERENCE_2
  local INDIRECT_ARRAY_2=()

  local VARIABLE_NAME_1="${1}"
  local VARIABLE_NAME_2="${2}"

  local ARRAY_INDEX

  __assertion_value_check "${VARIABLE_NAME_1}"
  __assertion_value_check "${VARIABLE_NAME_2}"

  assert_is_array "${VARIABLE_NAME_1}"
  assert_is_array "${VARIABLE_NAME_2}"

  INDIRECT_REFERENCE_1="${VARIABLE_NAME_1}[@]"
  INDIRECT_ARRAY_1=("${!INDIRECT_REFERENCE_1}")
  INDIRECT_REFERENCE_2="${VARIABLE_NAME_2}[@]"
  INDIRECT_ARRAY_2=("${!INDIRECT_REFERENCE_2}")

  assert_equals \
    "${#INDIRECT_ARRAY_1[*]}" \
    "${#INDIRECT_ARRAY_2[*]}" \
    "$(
      echo -n " the array '${VARIABLE_NAME_1}' has length '${#INDIRECT_ARRAY_1[*]}',"
      echo -n " the array '${VARIABLE_NAME_2}' has length '${#INDIRECT_ARRAY_2[*]}'"
    )"

  for ((ARRAY_INDEX = 0; ARRAY_INDEX < "${#INDIRECT_ARRAY_1[*]}"; ARRAY_INDEX++)); do
    assert_equals \
      "${INDIRECT_ARRAY_1[ARRAY_INDEX]}" \
      "${INDIRECT_ARRAY_2[ARRAY_INDEX]}" \
      "$(
        echo -n " at index '${ARRAY_INDEX}'"
        echo -n " the array '${VARIABLE_NAME_1}' has element '${INDIRECT_ARRAY_1[ARRAY_INDEX]}',"
        echo -n " array '${VARIABLE_NAME_2}' has element '${INDIRECT_ARRAY_2[ARRAY_INDEX]}'"
      )"
  done
}

assert_array_length() {
  # $1: the expected length
  # $2: the variable name
  # $3: an optional message

  local EXPECTED_LENGTH="${1}"
  local INDIRECT_REFERENCE
  local INDIRECT_ARRAY=()
  local VARIABLE_NAME="${2}"

  __assertion_value_check "${VARIABLE_NAME}"
  assert_is_array "${VARIABLE_NAME}"

  INDIRECT_REFERENCE="${VARIABLE_NAME}[@]"
  INDIRECT_ARRAY=("${!INDIRECT_REFERENCE}")

  assert_equals "${EXPECTED_LENGTH}" "${#INDIRECT_ARRAY[*]}" "${3}"
}

assert_is_array() {
  # $1: the variable to check

  local VARIABLE_NAME="${1}"

  __assertion_value_check "${VARIABLE_NAME}"

  if ! declare -p "${VARIABLE_NAME}" 2> /dev/null | grep -q '^declare \-a'; then
    fail " '${VARIABLE_NAME}' is NOT an array"
  fi
}

assert_is_function() {
  # $1: the variable to check

  local VARIABLE_NAME="${1}"

  __assertion_value_check "${VARIABLE_NAME}"

  if ! stdlib.fn.query.is_fn; then
    fail " '${VARIABLE_NAME}' is NOT a function"
  fi
}

assert_output() {
  # $1: the expected output string to match

  local EXPECTED_OUTPUT_STRING="${1}"

  __assertion_value_check "${EXPECTED_OUTPUT_STRING}"

  if [[ -z "${TEST_OUTPUT}" ]]; then
    fail " the 'TEST_OUTPUT' value is empty, consider using '_capture_output'"
  fi

  assert_equals "${EXPECTED_OUTPUT_STRING}" "${TEST_OUTPUT}" " the expected output string was not generated"
}

assert_rc() {
  # $1: the expected return status code

  local EXPECTED_STATUS_CODE="${1}"

  __assertion_value_check "${EXPECTED_STATUS_CODE}"

  if [[ -z "${TEST_RC}" ]]; then
    fail " the 'TEST_RC' value is empty, consider using '_capture_rc'"
  fi

  assert_equals "${EXPECTED_STATUS_CODE}" "${TEST_RC}" " the expected status code was not returned"
}

assert_snapshot() {
  # $1: a path relative to the test directory containing a text file

  local EXPECTED_OUTPUT
  local SNAPSHOT_FILENAME="${1}"

  __assertion_value_check "${SNAPSHOT_FILENAME}"

  if [[ ! -f "${SNAPSHOT_FILENAME}" ]]; then
    fail " the file '${SNAPSHOT_FILENAME}' does not exist"
  fi

  EXPECTED_OUTPUT="$(< "${SNAPSHOT_FILENAME}")"

  assert_equals "${EXPECTED_OUTPUT}" "${TEST_OUTPUT}" " the contents of '${SNAPSHOT_FILENAME}' does not match the received output"
}
