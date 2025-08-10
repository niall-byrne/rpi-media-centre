#!/bin/bash
# @file array.sh
# @brief A library of array assertions for testing.
# @description
#   This library provides array-related assertion functions for use with a testing framework like `bash_unit`.

# stdlib array extensions to bash_unit assertions

set -eo pipefail

# @description Asserts that two arrays are equal.
# It checks if both arrays have the same length and the same elements in the same order.
# @arg $1 string The name of the first array to compare.
# @arg $2 string The name of the second array to compare.
assert_array_equals() {
  local indirect_reference_1
  local indirect_array_1=()
  local indirect_reference_2
  local indirect_array_2=()

  local variable_name_1="${1}"
  local variable_name_2="${2}"

  local array_index

  _testing.__assertion.value.check "${variable_name_1}"
  _testing.__assertion.value.check "${variable_name_2}"

  assert_is_array "${variable_name_1}"
  assert_is_array "${variable_name_2}"

  indirect_reference_1="${variable_name_1}[@]"
  indirect_array_1=("${!indirect_reference_1}")
  indirect_reference_2="${variable_name_2}[@]"
  indirect_array_2=("${!indirect_reference_2}")

  assert_equals \
    "${#indirect_array_1[*]}" \
    "${#indirect_array_2[*]}" \
    "$(
      #:nocov:
      # bashcov doesn't report this section correctly
      echo -n " the array '${variable_name_1}' has length '${#indirect_array_1[*]}',"
      echo -n " the array '${variable_name_2}' has length '${#indirect_array_2[*]}'"
    )"
  #:nocov:

  for ((array_index = 0; array_index < "${#indirect_array_1[*]}"; array_index++)); do
    assert_equals \
      "${indirect_array_1[array_index]}" \
      "${indirect_array_2[array_index]}" \
      "$(
        #:nocov:
        # bashcov doesn't report this section correctly
        echo -n " at index '${array_index}'"
        echo -n " the array '${variable_name_1}' has element '${indirect_array_1[array_index]}',"
        echo -n " array '${variable_name_2}' has element '${indirect_array_2[array_index]}'"
      )"
    #:nocov:
  done
}

# @description Asserts that an array has a specific length.
# @arg $1 integer The expected length.
# @arg $2 string The name of the array.
# @arg $3 string (optional) An optional message to display on failure.
assert_array_length() {
  local expected_length="${1}"
  local indirect_reference
  local indirect_array=()
  local variable_name="${2}"

  _testing.__assertion.value.check "${variable_name}"
  assert_is_array "${variable_name}"

  indirect_reference="${variable_name}[@]"
  indirect_array=("${!indirect_reference}")

  assert_equals "${expected_length}" "${#indirect_array[*]}" "${3}"
}

# @description Asserts that a variable is an array.
# @arg $1 string The name of the variable to check.
assert_is_array() {
  local variable_name="${1}"

  _testing.__assertion.value.check "${variable_name}"

  if ! declare -p "${variable_name}" 2> /dev/null | grep -q '^declare \-a'; then
    fail " '${variable_name}' is NOT an array"
  fi
}
