#!/bin/bash

# stdlib array extensions to bash_unit assertions

set -eo pipefail

assert_array_equals() {
  # $1: the first array to compare
  # $2: the second array to compare

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

assert_array_length() {
  # $1: the expected length
  # $2: the variable name
  # $3: an optional message

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

assert_is_array() {
  # $1: the variable to check

  local variable_name="${1}"

  _testing.__assertion.value.check "${variable_name}"

  if ! stdlib.array.query.is_array "${1}"; then
    fail " '${variable_name}' is NOT an array"
  fi
}
