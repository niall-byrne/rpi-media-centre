#!/bin/bash

# stdlib testing mock library

builtin set -eo pipefail

__MOCK_SEQUENCE_TRACKING="0"

# Mock Api                                  (all other values/methods are not considered stable)
# -----------------------------------------------------------------------------------------------------
# _mock.create                             - creates a new mock
#
# mock_object.mock.get.call (index)        - get the arguments as a $* string for the indexed mock call
# mock_object.mock.get.calls               - get string containing a newline separated $* line for each call
# mock_object.mock.get.count               - get a count of the number of times the mock was called
# mock_object.mock.get.keywords            - get the list of currently set keyword arguments the mock is tracking
#
# mock_object.mock.set.keywords            - set one or more keyword arguments for the mock to track
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
#
# Sequence
# -----------------------------------------------------------------------------------------------------
#
# _mock.sequence
#
# _mock.sequence.assert_is                  - calls assert_array_equals against the given array of argument strings
# _mock.sequence.assert_empty               - calls assert_array_equals against the given array of argument strings
# _mock.sequence.clear                      - clears the current sequence of recorded mock calls
# _mock.sequence.record.start               - begins recording a new (cleared) sequence of all mock calls
# _mock.sequence.record.stop                - stops recording the current sequence of mock calls
#                                           - NOTE: calling any _mock.sequence assertion will also stop recording
# _mock.sequence.record.resume              - resumes recording all mock calls without clearing the existing sequence

_testing._mock.compile() {
  local mock_component
  local mock_component_file_set=()

  mock_component_file_set=(
    "${STDLIB_DIRECTORY}/testing/mock/components/defaults.sh"
    "${STDLIB_DIRECTORY}/testing/mock/components/main.sh"
    "${STDLIB_DIRECTORY}/testing/mock/components/call.sh"
    "${STDLIB_DIRECTORY}/testing/mock/components/controller.sh"
    "${STDLIB_DIRECTORY}/testing/mock/components/getter.sh"
    "${STDLIB_DIRECTORY}/testing/mock/components/setter.sh"
    "${STDLIB_DIRECTORY}/testing/mock/components/assertion.sh"
  )

  # shellcheck disable=SC1090
  source <({
    builtin echo "_mock.__generate_mock() {"
    builtin echo "  __mock.persistence.create \"\${1}\" \"\${2}\""
    builtin echo "builtin eval \"\$(\"${_STDLIB_BINARY_CAT}\" <<EOF"

    for mock_component in "${mock_component_file_set[@]}"; do
      builtin echo -e "\n\n# === component start =========================="
      "${_STDLIB_BINARY_SED}" -e "1,10d" "${mock_component}" | "${_STDLIB_BINARY_HEAD}" -n -2
      builtin echo -e "# === component end ============================\n\n"
    done

    builtin echo "EOF"
    builtin echo ")\""
    builtin echo "}"
  })

  __mock.persistence.registry.create
  __mock.persistence.sequence.initialize
}

_mock.create() {
  # $1: the variable name to create

  local _mock_sanitized_fn_name
  local _mock_escaped_fn_name
  local _mock_attribute
  local _mock_restricted_attribute_boolean=0

  if [[ "${#@}" != 1 ]] || [[ -z "${1}" ]]; then
    _testing.error "${FUNCNAME[0]}: $(__testing.protected stdlib.message.get ARGUMENTS_INVALID)"
    return 127
  fi

  if ! __testing.protected stdlib.fn.query.is_valid_name "${1}" ||
    __testing.protected stdlib.array.query.is_contains "${1}" _MOCK_ATTRIBUTES_RESTRICTED; then
    _testing.error "${FUNCNAME[0]}: $(_testing.message.get MOCK_TARGET_INVALID "${1}")"
    return 126
  fi

  builtin printf -v "_mock_escaped_fn_name" "%q" "${1}"

  _mock_sanitized_fn_name="$(__mock.create_sanitized_fn_name "${_mock_escaped_fn_name}")"

  if __testing.protected stdlib.fn.query.is_fn "${_mock_escaped_fn_name}"; then
    __testing.protected stdlib.fn.derive.clone "${_mock_escaped_fn_name}" "${_mock_escaped_fn_name}____copy_of_original_implementation"
  fi

  _mock.__generate_mock "${_mock_escaped_fn_name}" "${_mock_sanitized_fn_name}"
}

_mock.delete() {
  # $1: the mock name to delete (restoring the original implementation)

  __testing.protected stdlib.fn.assert.is_fn "${1}" || return 127
  __testing.protected stdlib.fn.assert.is_fn "${1}.mock.set.subcommand" || return 127

  builtin unset -f "${1}"

  while IFS= builtin read -r mocked_function; do
    mocked_function="${mocked_function/" ()"/}"
    mocked_function="${mocked_function%?}"
    builtin unset -f "${mocked_function/" ()"/}"
  done <<< "$(builtin declare -f | ${_STDLIB_BINARY_GREP} -E "^${1}.mock.* ()")"

  if __testing.protected stdlib.fn.query.is_fn "${1}____copy_of_original_implementation"; then
    __testing.protected stdlib.fn.derive.clone "${1}____copy_of_original_implementation" "${1}"
  fi
}

_mock.clear_all() {
  __mock.persistence.registry.apply_to_all "clear"
}

_mock.reset_all() {
  __mock.persistence.registry.apply_to_all "reset"
}
