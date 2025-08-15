#!/bin/bash

# stdlib testing parametrize create component

set -eo pipefail

@parametrize._components.create.array.fn_variant_tags() {
  # $1: the variable to store the calculated variant tag padding in
  # #2: the array to store the variant tags in
  # $@: an array of function names to convert to variant tags

  local arg_name_for_padding_value="${1}"
  local arg_name_for_variant_array="${2}"

  local padding_value="${!1}"
  local parametrizer_function_name=""
  local variant_index=""
  local variant_tag=""
  local variants=()

  shift
  shift

  for ((variant_index = 1; variant_index <= "${#@}"; variant_index++)); do
    parametrizer_function_name="${!variant_index}"
    @parametrize._components.validate.fn_name.parametrizer "${parametrizer_function_name}" || return 126
    variant_tag="${parametrizer_function_name/${_PARAMETRIZE_MULTIPLE_PREFIX}/}"
    variants+=("${variant_tag}")
    if [[ "${#variant_tag}" -gt "${padding_value}" ]]; then
      padding_value="${#variant_tag}"
    fi
  done

  printf -v "${arg_name_for_padding_value}" "%s" "${padding_value}"
  eval "${arg_name_for_variant_array}=($(printf '%q ' "${variants[@]}"))"
}

@parametrize._components.create.fn.test_variant() {
  # $1: the test function variant to create
  # $2: the original test function name
  # $3: the original test function reference
  # $4: the name of the array in which the environment variables are stored
  # $5: the name of the array in which the fixture commands are stored
  # $6: the name of the array in which the scenario values are stored

  local array_indirect_environment_variables=()
  local array_indirect_environment_variables_reference
  local array_indirect_fixture_commands=()
  local array_indirect_fixture_commands_reference
  local array_indirect_scenario_definition=()
  local array_indirect_scenario_definition_reference
  local original_test_function_name="${2}"
  local original_test_function_reference="${3}"
  local scenario_debug_message=""
  local scenario_index
  local test_function_variant_name="${1}"

  array_indirect_environment_variables_reference="${4}[@]"
  array_indirect_environment_variables=("${!array_indirect_environment_variables_reference}")
  array_indirect_fixture_commands_reference="${5}[@]"
  array_indirect_fixture_commands=("${!array_indirect_fixture_commands_reference}")
  array_indirect_scenario_definition_reference="${6}[@]"
  array_indirect_scenario_definition=("${!array_indirect_scenario_definition_reference}")

  #:nocov:
  # bashcov doesn't report this section correctly
  eval "
  ${test_function_variant_name}(){
  $(
    if [[ "${_PARAMETRIZE_SHOW_ORIGINAL_TEST_NAMES}" == "1" ]]; then
      echo -e "echo -ne '\n                ${STDLIB_COLOUR_GREY}${original_test_function_name} ...${STDLIB_COLOUR_NC}'"
    fi

    scenario_debug_message+=$'\n'
    scenario_debug_message+="'Parametrize Scenario: ${array_indirect_scenario_definition[0]}'"$'\n'

    for ((scenario_index = 0; scenario_index < "${#array_indirect_environment_variables[@]}"; scenario_index++)); do
      scenario_debug_message+="'${array_indirect_environment_variables[scenario_index]}=\"${array_indirect_scenario_definition[((scenario_index + 1))]}\"'"$'\n'
      echo "  printf -v \"${array_indirect_environment_variables[scenario_index]}\" \"%s\" \"${array_indirect_scenario_definition[((scenario_index + 1))]}\""
    done

    for ((scenario_index = 0; scenario_index < "${#array_indirect_fixture_commands[@]}"; scenario_index++)); do
      scenario_debug_message+="'Fixture Command=\"${array_indirect_fixture_commands[scenario_index]}\"'"$'\n'
      printf "%s\n" "${array_indirect_fixture_commands[scenario_index]}"
    done

    if [[ "${_PARAMETRIZE_DEBUG}" == "1" ]]; then
      @parametrize._components.debug.message "${scenario_debug_message}"
    fi
  )
    ${original_test_function_reference};
  }
  "
  #:nocov:
}

@parametrize._components.create.string.padded_test_fn_variant_name() {
  # $1: the function name to parametrize
  # $2: the function variant's description
  # $3: the length of the longest variant description for padding

  local padded_variant_name

  padded_variant_name="${2// /_}"

  if (("${3}" > "${#2}")); then
    padded_variant_name="$(stdlib.string.pad.right "$(("${3}" - "${#2}"))" "${padded_variant_name}")"
    padded_variant_name="${padded_variant_name// /_}"
  fi

  echo "${1/"${_PARAMETRIZE_VARIANT_TAG}"/"${padded_variant_name}"}"
}
