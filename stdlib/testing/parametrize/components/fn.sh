#!/bin/bash

# stdlib testing parametrize fn component

set -eo pipefail

@parametrize._components.fn() {
  #:nocov:
  # bashcov doesn't report this section correctly
  eval "
  ${_P_WRAPPED_FN_NAME}(){
  $(
    if [[ -n "${_PARAMETRIZE_SHOW_ORIGINAL_TEST_NAMES}" ]]; then
      echo -e "echo -ne '\n                ${RPI_COLOUR_GRAY}${_P_ORIGINAL_FN_NAME} ...${RPI_COLOUR_NC}'"
    fi

    _P_SCENARIO_DEBUG+=$'\n'
    _P_SCENARIO_DEBUG+="'Parametrize Scenario: ${_P_STACK_SCENARIOS[0]}'"$'\n'

    for ((_P_SCENARIO_INDEX = 0; _P_SCENARIO_INDEX < "${#_P_STACK_ENV_VARS[@]}"; _P_SCENARIO_INDEX++)); do
      _P_SCENARIO_DEBUG+="'${_P_STACK_ENV_VARS[_P_SCENARIO_INDEX]}=\"${_P_STACK_SCENARIOS[((_P_SCENARIO_INDEX + 1))]}\"'"$'\n'
      echo "  printf -v \"${_P_STACK_ENV_VARS[_P_SCENARIO_INDEX]}\" \"%s\" \"${_P_STACK_SCENARIOS[((_P_SCENARIO_INDEX + 1))]}\""
    done

    for ((_P_SCENARIO_INDEX = 0; _P_SCENARIO_INDEX < "${#_P_STACK_FIXTURES[@]}"; _P_SCENARIO_INDEX++)); do
      _P_SCENARIO_DEBUG+="'Fixture Command=\"${_P_STACK_FIXTURES[_P_SCENARIO_INDEX]}\"'"$'\n'
      printf "%s\n" "${_P_STACK_FIXTURES[_P_SCENARIO_INDEX]}"
    done

    if [[ "${_PARAMETRIZE_DEBUG}" == "1" ]]; then
      @parametrize._components.debug.message "${_P_SCENARIO_DEBUG}"
    fi
  )
    ${_P_ORIGINAL_FN_REFERENCE};
  }
  "
  #:nocov:
}
