#!/bin/bash

# stdlib testing parametrize create component

builtin set -eo pipefail

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
    variant_tag="${parametrizer_function_name/${_PARAMETRIZE_PARAMETRIZER_PREFIX}/}"
    variants+=("${variant_tag}")
    if [[ "${#variant_tag}" -gt "${padding_value}" ]]; then
      padding_value="${#variant_tag}"
    fi
  done

  builtin printf -v "${arg_name_for_padding_value}" "%s" "${padding_value}"
  builtin eval "${arg_name_for_variant_array}=($(builtin printf '%q ' "${variants[@]}"))"
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

  builtin eval "
  ${test_function_variant_name}(){
  $(
    if [[ "${_PARAMETRIZE_SHOW_ORIGINAL_TEST_NAMES}" == "1" ]]; then
      builtin echo -e "builtin echo -ne '\n                $(
        __testing.protected stdlib.string.colour \
          "${STDLIB_TESTING_THEME_PARAMETRIZE_ORIGINAL_TEST_NAMES}" \
          "${original_test_function_name} ..."
      )'"
    fi

    builtin echo "  builtin printf -v \"PARAMETRIZE_SCENARIO_NAME\" \"%s\" \"${array_indirect_scenario_definition[0]}\""

    scenario_debug_message+=$'\n'
    scenario_debug_message+="$(_testing.message.get PARAMETRIZE_HEADER_SCENARIO): "
    scenario_debug_message+="\"${array_indirect_scenario_definition[0]}\""
    scenario_debug_message+=$'\n'

    for ((scenario_index = 0; scenario_index < "${#array_indirect_environment_variables[@]}"; scenario_index++)); do
      scenario_debug_message+="${array_indirect_environment_variables[scenario_index]}: \"${array_indirect_scenario_definition[((scenario_index + 1))]}\""$'\n'
      builtin echo "  builtin printf -v \"${array_indirect_environment_variables[scenario_index]}\" \"%s\" \"${array_indirect_scenario_definition[((scenario_index + 1))]}\""
    done

    for ((scenario_index = 0; scenario_index < "${#array_indirect_fixture_commands[@]}"; scenario_index++)); do
      scenario_debug_message+="$(_testing.message.get PARAMETRIZE_PREFIX_FIXTURE_COMMAND): "
      scenario_debug_message+="\"${array_indirect_fixture_commands[scenario_index]}\""
      scenario_debug_message+=$'\n'
      builtin printf "%s\n" "${array_indirect_fixture_commands[scenario_index]}"
    done

    if [[ "${_PARAMETRIZE_DEBUG}" == "1" ]]; then
      @parametrize._components.debug.message "${scenario_debug_message}"
    fi
  )
    ${original_test_function_reference};
  }
  "
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

  builtin echo "${1/"${_PARAMETRIZE_VARIANT_TAG}"/"${padded_variant_name}"}"
}
