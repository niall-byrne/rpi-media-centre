#!/bin/bash

# stdlib testing mock library

set -eo pipefail

# Mock Api                                  (all other values/methods are not considered stable)
# -----------------------------------------------------------------------------------------------------
# _mock.create                             - creates a new mock
#
# mock_object.mock.get.call (index)        - get the arguments as a $* string for the indexed mock call
# mock_object.mock.get.calls               - get string containing a newline separated $* line for each call
# mock_object.mock.get.count               - get a count of the number of times the mock was called
#
#
# mock_object.mock.set.pipeable            - set a boolean to allow the mock to receive piped input
# mock_object.mock.set.rc                  - set the return code the mock returns when called
# mock_object.mock.set.side_effects        - a (FIFO) queue of commands, one of each is executed for each
#                                            call made to the mock
# mock_object.mock.set.stdout              - set the stdout content the mock generates when called
# mock_object.mock.set.stderr              - set the stderr content the mock generates when called
# mock_object.mock.set.subcommand          - set a subcommand function the mock will call with the same
#                                            arguments it receives on each call
#
# mock_object.clear                        - clear all calls made to this mock
# mock_object.reset                        - clear all calls, as well as all set values on this mock
#
# Assertions
# -----------------------------------------------------------------------------------------------------
#
# mock_object.mock.assert_any_call_is      - calls assert_equals against the given argument string
# mock_object.mock.assert_count_is         - calls assert_equals against the given call count
# mock_object.mock.assert_call_n_is        - calls assert_equals against a given call index, and argument string
# mock_object.mock.assert_calls_are        - calls assert_array_equals against the given array of argument strings
# mock_object.mock.assert_called_once_with - calls assert_equals against the given argument string
# mock_object.mock.assert_not_called       - calls assert_equals with 0 against the call count

_testing._mock.compile() {
  local MOCK_COMPONENT
  local MOCK_COMPONENT_FILE_SET=()

  MOCK_COMPONENT_FILE_SET=(
    "${STDLIB_DIRECTORY}/testing/mock/components/defaults.sh"
    "${STDLIB_DIRECTORY}/testing/mock/components/main.sh"
    "${STDLIB_DIRECTORY}/testing/mock/components/controller.sh"
    "${STDLIB_DIRECTORY}/testing/mock/components/getter.sh"
    "${STDLIB_DIRECTORY}/testing/mock/components/setter.sh"
    "${STDLIB_DIRECTORY}/testing/mock/components/assertion.sh"
  )

  #:nocov:
  # bashcov doesn't report this section correctly
  # shellcheck disable=SC1090
  source <({
    echo "_mock.__generate_mock() {"
    echo "  __mock.persistence.create \"\${1}\" \"\${2}\""
    echo "eval \"\$(cat <<EOF"

    for MOCK_COMPONENT in "${MOCK_COMPONENT_FILE_SET[@]}"; do
      echo -e "\n\n# === component start =========================="
      sed -e "1,10d" "${MOCK_COMPONENT}" | head -n -2
      echo -e "# === component end ============================\n\n"
    done

    echo "EOF"
    echo ")\""
    echo "}"
  })
  #:nocov:
}

_mock.create() {
  # $1: the variable name to create

  local sanitized_variable_name

  sanitized_variable_name="$(_mock.__create_sanitized_function_name "${1}")"

  if stdlib.fn.query.is_fn "${1}"; then
    stdlib.fn.derive.clone "${1}" "${1}____copy_of_original_implementation"
  fi

  _mock.__generate_mock "${1}" "${sanitized_variable_name}"
}

_mock.delete() {
  # $1: the mock name to delete (restoring the original implementation)

  stdlib.fn.assert.is_fn "${1}" || return 127
  stdlib.fn.assert.is_fn "${1}.mock.set.subcommand" || return 127

  unset -f "${1}"

  while IFS= read -r mocked_function; do
    mocked_function="${mocked_function/" ()"/}"
    mocked_function="${mocked_function%?}"
    unset -f "${mocked_function/" ()"/}"
    #:nocov:
    # bashcov doesn't report this section correctly
  done <<< "$(declare -f | grep -E "^${1}.mock.* ()")"
  #:nocov:

  if stdlib.fn.query.is_fn "${1}____copy_of_original_implementation"; then
    stdlib.fn.derive.clone "${1}____copy_of_original_implementation" "${1}"
  fi
}

_mock.__create_sanitized_function_name() {
  # $1: the function name to sanitize

  local _fn_name_sanitized
  local _fn_name_original="${1}"

  _fn_name_sanitized="${_fn_name_original//./____dot____}"
  _fn_name_sanitized="${_fn_name_sanitized//@/____at_sign____}"

  echo "${_fn_name_sanitized}_sanitized"
}

_mock.clear_all() {
  __mock.persistence.registry.apply_to_all "clear"
}

_mock.reset_all() {
  __mock.persistence.registry.apply_to_all "reset"
}
