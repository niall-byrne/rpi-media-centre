#!/bin/bash

# pictl testing parametrize library

set -eo pipefail

_PARAMETRIZE_DEBUG="${PARAMETRIZE_DEBUG:-''}"
_PARAMETRIZE_FIELD_SEPERATOR=","
_PARAMETRIZE_FIXTURE_COMMAND_PREFIX="@fixture "
_PARAMETRIZE_MULTIPLE_PREFIX="@parametrize_with_"
_PARAMETRIZE_SHOW_ORIGINAL_TEST_NAMES=""
_PARAMETRIZE_VARIANT_TAG="@vary"
_PARAMETRIZE_GENERATED_FUNCTIONS=()

@parametrize() {
  # $1: (required) the name of the test function to parametrize
  # $@: (optional) test fixtures (or setup commands to execute) before test execution begins.
  #     These commands can have access to the variables that have been parametrized for
  #     more complex scenario generation.
  #     i.e. "@fixture function_name" or "@fixture echo hello"
  # $X: (required) a comma separate list of variable names
  #     i.e. VAR1,VAR2,VAR3
  # $@: (required) a comma separated list of a scenario name, and values comprising a test scenario
  #     i.e. SCENARIO_NAME,VALUE1,VALUE2,VALUE3

  local _P_CONFIGURATION_LINE=""
  local _P_CONFIGURATION_LINES=()
  local _P_INDEX=0
  local _P_ORIGINAL_FN_NAME=""
  local _P_ORIGINAL_FN_REFERENCE=""
  local _P_PADDING=0
  local _P_SCENARIO_INDEX=0
  local _P_STACK_ENV_VARS=()
  local _P_STACK_FIXTURES=()
  local _P_STACK_SCENARIOS=()
  local _P_WRAPPED_FN_NAME=""
  local _P_EMIT_FUNCTION_NAMES="${_P_EMIT_FUNCTION_NAMES:-0}"

  _P_ORIGINAL_FN_NAME="${1}"
  _P_ORIGINAL_FN_REFERENCE="__parametrized_original_function_definition_${1}"

  @parametrize.__validate_test_function_name "${_P_ORIGINAL_FN_NAME}"

  @parametrize.__clone_function \
    "${_P_ORIGINAL_FN_NAME}" \
    "${_P_ORIGINAL_FN_REFERENCE}"

  unset -f "${1}"

  shift

  _P_CONFIGURATION_LINES=("${@}")
  @parametrize.__configuration_read_header "${_P_CONFIGURATION_LINES[@]}"

  for ((_P_INDEX = 0; "${_P_INDEX}" < "${#_P_CONFIGURATION_LINES[@]}"; _P_INDEX++)); do
    _P_CONFIGURATION_LINE="${_P_CONFIGURATION_LINES[_P_INDEX]}"
    IFS="${_PARAMETRIZE_FIELD_SEPERATOR}" read -ra _P_STACK_SCENARIOS <<< "${_P_CONFIGURATION_LINE}"
    @parametrize.__configuration_validate_scenario
    if [[ "${#_P_STACK_SCENARIOS[0]}" -gt "${_P_PADDING}" ]]; then
      _P_PADDING="${#_P_STACK_SCENARIOS[0]}"
    fi
  done

  for ((_P_INDEX = 0; "${_P_INDEX}" < "${#_P_CONFIGURATION_LINES[@]}"; _P_INDEX++)); do
    _P_CONFIGURATION_LINE="${_P_CONFIGURATION_LINES[_P_INDEX]}"
    IFS="${_PARAMETRIZE_FIELD_SEPERATOR}" read -ra _P_STACK_SCENARIOS <<< "${_P_CONFIGURATION_LINE}"
    @parametrize.__configuration_validate_scenario

    _P_WRAPPED_FN_NAME="$(
      @parametrize.__generate_padded_variant_name \
        "${_P_ORIGINAL_FN_NAME}" \
        "${_P_STACK_SCENARIOS[0]}" \
        "${_P_PADDING}"
    )"

    eval "
${_P_WRAPPED_FN_NAME}(){
$(
      if [[ -n "${_PARAMETRIZE_SHOW_ORIGINAL_TEST_NAMES}" ]]; then
        echo -e "echo -ne '\n                ${RPI_COLOUR_GRAY}${_P_ORIGINAL_FN_NAME} ...${RPI_COLOUR_NC}'"
      fi

      if [[ "${_PARAMETRIZE_DEBUG}" == "1" ]]; then
        echo "echo "$'\n'
        echo "echo 'Parametrize Scenario: ${_P_STACK_SCENARIOS[0]}'"
      fi

      for ((_P_SCENARIO_INDEX = 0; _P_SCENARIO_INDEX < "${#_P_STACK_ENV_VARS[@]}"; _P_SCENARIO_INDEX++)); do
        echo "  printf -v \"${_P_STACK_ENV_VARS[_P_SCENARIO_INDEX]}\" \"%s\" \"${_P_STACK_SCENARIOS[((_P_SCENARIO_INDEX + 1))]}\""

        if [[ "${_PARAMETRIZE_DEBUG}" == "1" ]]; then
          echo "echo '${_P_STACK_ENV_VARS[_P_SCENARIO_INDEX]}=\"${_P_STACK_SCENARIOS[((_P_SCENARIO_INDEX + 1))]}\"'"
        fi
      done

      for ((_P_SCENARIO_INDEX = 0; _P_SCENARIO_INDEX < "${#_P_STACK_FIXTURES[@]}"; _P_SCENARIO_INDEX++)); do
        if [[ "${_PARAMETRIZE_DEBUG}" == "1" ]]; then
          echo "echo 'Fixture Command=\"${_P_STACK_FIXTURES[_P_SCENARIO_INDEX]}\"'"
        fi
        printf "%s" "${_P_STACK_FIXTURES[_P_SCENARIO_INDEX]}"
      done
    )
  ${_P_ORIGINAL_FN_REFERENCE};
}
"
    _PARAMETRIZE_GENERATED_FUNCTIONS+=("${_P_WRAPPED_FN_NAME}")

  done
}

@parametrize_apply() {
  # $1: the name of the test function to parametrize
  # $@: a series of parametrize functions to apply to this function

  local _PM_COUNTER=0
  local _PM_CURRENT_FUNCTION
  local _PM_STACK_FUNCTIONS=()
  local _PM_WRAPPED_FN_NAME=""
  local _PM_WRAPPED_FN_REFERENCE=""

  local _PARAMETRIZED_STACK_VARIANTS=()
  local _PARAMETRIZED_PADDING_VALUE=0

  _PM_WRAPPED_FN_NAME="${1}"
  _PM_STACK_FUNCTIONS=("${@:2}")

  @parametrize.__validate_test_function_name "${_PM_WRAPPED_FN_NAME}"

  @parametrize.__create_variant_stack "${@:2}"

  for ((_PM_COUNTER = 0; _PM_COUNTER < "${#_PM_STACK_FUNCTIONS[@]}"; _PM_COUNTER++)); do
    _PM_CURRENT_FUNCTION="${_PM_STACK_FUNCTIONS[_PM_COUNTER]}"
    _PM_WRAPPED_FN_REFERENCE="$(
      @parametrize.__generate_padded_variant_name \
        "${_PM_WRAPPED_FN_NAME}" \
        "${_PARAMETRIZED_STACK_VARIANTS[_PM_COUNTER]}" \
        "${_PARAMETRIZED_PADDING_VALUE}"
    )"
    @parametrize.__clone_function \
      "${_PM_WRAPPED_FN_NAME}" \
      "${_PM_WRAPPED_FN_REFERENCE}"

    "${_PM_CURRENT_FUNCTION}" "${_PM_WRAPPED_FN_REFERENCE}"
  done

  unset -f "${_PM_WRAPPED_FN_NAME}"
}

@parametrize_compose() {
  # $1: the name of the test function to parametrize
  # $@: a series of parametrize functions to compose with this function

  local _PARAMETRIZE_GENERATED_FUNCTIONS=()
  local _PC_COUNTER=0
  local _PC_CURRENT_FUNCTION
  local _PC_STACK_FUNCTIONS=()
  local _PC_STACK_TARGETS=()
  local _PC_TEST_FN_REFERENCE="${1}"
  local _PC_TEST_TARGET

  _PC_STACK_FUNCTIONS=("${@:2}")

  @parametrize.__validate_test_function_name "${_PC_TEST_FN_REFERENCE}"
  @parametrize.__create_variant_stack "${@:2}"

  _PC_STACK_TARGETS=("${_PC_TEST_FN_REFERENCE}")
  for ((_PC_COUNTER = 0; _PC_COUNTER < "${#_PC_STACK_FUNCTIONS[@]}"; _PC_COUNTER++)); do
    _PC_CURRENT_FUNCTION="${_PC_STACK_FUNCTIONS[_PC_COUNTER]}"
    _PARAMETRIZE_GENERATED_FUNCTIONS=()
    for _PC_TEST_TARGET in "${_PC_STACK_TARGETS[@]}"; do
      "${_PC_CURRENT_FUNCTION}" "${_PC_TEST_TARGET}"
    done
    _PC_STACK_TARGETS=("${_PARAMETRIZE_GENERATED_FUNCTIONS[@]}")
  done

  unset -f "${1}"
}

@parametrize.__configuration_read_header() {
  # $@: the arguments passed to parametrize

  local _P_CONFIGURATION_INDEX=-1

  while [[ -n "${1}" ]]; do
    if _cli_pretty_string_starts_with "${_PARAMETRIZE_FIXTURE_COMMAND_PREFIX}" "${1}"; then
      _P_STACK_FIXTURES+=("${1/"${_PARAMETRIZE_FIXTURE_COMMAND_PREFIX}"/}")
      shift
      continue
    else
      IFS="${_PARAMETRIZE_FIELD_SEPERATOR}" read -ra _P_STACK_ENV_VARS <<< "${1}"
      shift
      break
    fi
  done

  _P_CONFIGURATION_LINES=("${@}")
}

@parametrize.__configuration_validate_scenario() {
  local VALIDATION_INDEX

  if (("${#_P_STACK_SCENARIOS[@]}" < "${#_P_STACK_ENV_VARS[@]}" + 1)); then
    echo "== Begin Scenario Values =="
    for ((VALIDATION_INDEX = 1; VALIDATION_INDEX < "${#_P_STACK_ENV_VARS[@]}"; VALIDATION_INDEX++)); do
      echo "${_P_STACK_ENV_VARS[VALIDATION_INDEX]} == ${_P_STACK_SCENARIOS[VALIDATION_INDEX + 1]}"
    done
    echo "== End Scenario Values =="
    _test_error \
      "Misconfigured parametrize parameters!" \
      "Scenario Name: '${_P_STACK_SCENARIOS[0]}'" \
      "Variables: '${_P_STACK_ENV_VARS[*]}' = ${#_P_STACK_ENV_VARS[@]} variables" \
      "Value Set: '${_P_STACK_SCENARIOS[*]:1}' = $((${#_P_STACK_SCENARIOS[@]} - 1)) values" \
      "Fixture Commands: $(printf "'%s' " "${_P_STACK_FIXTURES[@]}")"
  fi
}

@parametrize.__create_variant_stack() {
  # $@: the array of functions

  local __INDEX=""
  local __FUNCTION=""
  local __VARIANT=""
  for ((__INDEX = 1; __INDEX <= "${#@}"; __INDEX++)); do
    __FUNCTION="${!__INDEX}"
    @parametrize.__validate_parametrize_apply_function_name "${__FUNCTION}"
    __VARIANT="${__FUNCTION/${_PARAMETRIZE_MULTIPLE_PREFIX}/}"
    _PARAMETRIZED_STACK_VARIANTS+=("${__VARIANT}")
    if [[ "${#__VARIANT}" -gt "${_PARAMETRIZED_PADDING_VALUE}" ]]; then
      _PARAMETRIZED_PADDING_VALUE="${#__VARIANT}"
    fi
  done
}

@parametrize.__generate_padded_variant_name() {
  # $1: the function name to parametrize
  # $2: the function variant's description
  # $3: the length of the longest variant description for padding

  local PADDED_VARIANT_NAME

  PADDED_VARIANT_NAME="${2// /_}"

  if (("${3}" > "${#2}")); then
    PADDED_VARIANT_NAME="$(_cli_pretty_pad_right "$(("${3}" - "${#2}"))" "${PADDED_VARIANT_NAME}")"
    PADDED_VARIANT_NAME="${PADDED_VARIANT_NAME// /_}"
  fi

  echo "${1/"${_PARAMETRIZE_VARIANT_TAG}"/"${PADDED_VARIANT_NAME}"}"
}

@parametrize.__validate_test_function_name() {
  # $1: the test function name to validate

  if [[ "${1}" != *"${_PARAMETRIZE_VARIANT_TAG}"* ]]; then
    _test_error "The function '${1}' doesn't contain a '${_PARAMETRIZE_VARIANT_TAG}' tag in it's name, please rename this function !"
  fi
}

@parametrize.__validate_function_exists() {
  # $1: the function name to validate

  declare -f \
    "${1}" > /dev/null ||
    _test_error "The function '${1}' cannot be parametrized!  It doesn't appear to exist!"
}

@parametrize.__validate_parametrize_apply_function_name() {
  # $1: the function name to validate for parametrize multiple

  if ! _cli_pretty_string_starts_with "${_PARAMETRIZE_MULTIPLE_PREFIX}" "${1}"; then
    _test_error "The function '${1}' cannot be used in a parametrize series!  It's name must be prefixed with '${_PARAMETRIZE_MULTIPLE_PREFIX}' !"
  fi
}

@parametrize.__clone_function() {
  # $1: the original function name
  # $2: the function's new reference name

  local _WRAP_FN_NAME="${1}"
  local _WRAP_FN_REFERENCE="${2}"

  @parametrize.__validate_function_exists "${_WRAP_FN_NAME}"

  eval "$(
    echo "${_WRAP_FN_REFERENCE}()"
    declare -f "${_WRAP_FN_NAME}" | tail -n +2
  )"
}
