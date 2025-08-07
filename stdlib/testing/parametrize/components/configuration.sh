#!/bin/bash

# stdlib testing parametrize configuration component

set -eo pipefail

@parametrize._components.configuration.parse() {
  # $@: the arguments passed to parametrize

  @parametrize._components.configuration.parse_header "${@}"
  @parametrize._components.configuration.parse_scenarios "${_P_CONFIGURATION_LINES[@]}"
}

@parametrize._components.configuration.parse_header() {
  # $@: the arguments passed to parametrize

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

@parametrize._components.configuration.parse_scenarios() {
  # $@: the arguments passed to parametrize

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
