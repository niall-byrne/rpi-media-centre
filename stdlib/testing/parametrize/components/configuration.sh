#!/bin/bash

# stdlib testing parametrize configuration component

builtin set -eo pipefail

@parametrize._components.configuration.parse() {
  # $1: the name of the array containing the configuration to parse
  # $2: the name of the variable to store the configuration index where scenarios begin
  # $3: the name of the array in which to store the environment variables
  # $4: the name of the array in which to store the fixture commands
  # $5: the name of the variable to store the variant padding value

  local parse_configuration_array_indirect_reference
  local parse_configuration_array=()
  local parse_configuration_array_index=0
  local parse_env_var_array_name
  local parse_fixture_commands_array_indirect_reference
  local parse_fixture_commands_array=()
  local parse_variant_padding_value=0

  parse_configuration_array_indirect_reference="${1}[@]"
  parse_configuration_array=("${!parse_configuration_array_indirect_reference}")
  parse_env_var_array_name="${3}"
  parse_fixture_commands_array_indirect_reference="${4}[@]"
  parse_fixture_commands_array=("${!parse_fixture_commands_array_indirect_reference}")

  @parametrize._components.configuration.parse_header "${parse_configuration_array[@]}" || return "$?"
  builtin printf -v "${2}" "%s" "${parse_configuration_array_index}"
  @parametrize._components.configuration.parse_scenarios "${parse_configuration_array[@]:"${parse_configuration_array_index}"}" || return "$?"

  if [[ "${#parse_fixture_commands_array[@]}" == "0" ]]; then
    builtin eval "${4}=()"
  else
    builtin eval "${4}=($(builtin printf '%q ' "${parse_fixture_commands_array[@]}"))"
  fi

  builtin printf -v "${5}" "%s" "${parse_variant_padding_value}"
}

@parametrize._components.configuration.parse_header() {
  # $@: the parametrize configuration to parse the header from
  # consumes and modifies the local variables from @parametrize._components.configuration.parse

  while [[ -n "${1}" ]]; do
    ((parse_configuration_array_index = parse_configuration_array_index + 1))
    if stdlib.string.query.starts_with "${_PARAMETRIZE_FIXTURE_COMMAND_PREFIX}" "${1}"; then
      parse_fixture_commands_array+=("${1/"${_PARAMETRIZE_FIXTURE_COMMAND_PREFIX}"/}")
      shift
      builtin continue
    else
      __testing.protected stdlib.array.make.from_string \
        "${parse_env_var_array_name?}" \
        "${_PARAMETRIZE_FIELD_SEPARATOR}" \
        "${1}"
      shift
      builtin break
    fi
  done
}

@parametrize._components.configuration.parse_scenarios() {
  # $@: the parametrize configuration to parse scenarios from
  # consumes and modifies the local variables from @parametrize._components.configuration.parse

  local parse_scenario_array=()

  while [[ -n "${1}" ]]; do
    ((parse_configuration_array_index++))

    __testing.protected stdlib.array.make.from_string \
      parse_scenario_array \
      "${_PARAMETRIZE_FIELD_SEPARATOR}" \
      "${1}"

    @parametrize._components.validate.scenario \
      "${parse_env_var_array_name}" \
      parse_fixture_commands_array \
      parse_scenario_array || return "$?"

    if [[ "${#parse_scenario_array[0]}" -gt "${parse_variant_padding_value}" ]]; then
      parse_variant_padding_value="${#parse_scenario_array[0]}"
    fi
    shift
  done
}
