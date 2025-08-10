#!/bin/bash
# @file configuration.sh
# @brief A component for parsing parametrization configurations.
# @description
#   This script is a component of the parametrization framework. It is not meant to be sourced directly.
#   It provides functions to parse the configuration for a parametrized test.

# stdlib testing parametrize configuration component

set -eo pipefail

# @description Parses the parametrization configuration.
# This is an internal function.
# @arg $@ The arguments passed to parametrize.
@parametrize._components.configuration.parse() {
  @parametrize._components.configuration.parse_header "${@}"
  @parametrize._components.configuration.parse_scenarios "${_P_CONFIGURATION_LINES[@]}"
}

# @description Parses the header of the parametrization configuration.
# This is an internal function.
# @arg $@ The arguments passed to parametrize.
@parametrize._components.configuration.parse_header() {
  local _P_CONFIGURATION_INDEX=-1

  while [[ -n "${1}" ]]; do
    if stdlib.string.query.starts_with "${_PARAMETRIZE_FIXTURE_COMMAND_PREFIX}" "${1}"; then
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

# @description Parses the scenarios of the parametrization configuration.
# This is an internal function.
# @arg $@ The arguments passed to parametrize.
@parametrize._components.configuration.parse_scenarios() {
  local _P_INDEX=0
  local _P_CONFIGURATION_LINES=("${@}")

  for ((_P_INDEX = 0; "${_P_INDEX}" < "${#_P_CONFIGURATION_LINES[@]}"; _P_INDEX++)); do
    _P_CONFIGURATION_LINE="${_P_CONFIGURATION_LINES[_P_INDEX]}"
    IFS="${_PARAMETRIZE_FIELD_SEPERATOR}" read -ra _P_STACK_SCENARIOS <<< "${_P_CONFIGURATION_LINE}"
    @parametrize._components.validate.scenario
    if [[ "${#_P_STACK_SCENARIOS[0]}" -gt "${_P_PADDING}" ]]; then
      _P_PADDING="${#_P_STACK_SCENARIOS[0]}"
    fi
  done
}
