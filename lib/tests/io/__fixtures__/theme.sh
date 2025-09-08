#!/bin/bash

_testing.load "${RPI_WORKING_DIRECTORY}/lib/defaults.sh"

_fixture_mocked_complete_theme() {
  local all_theme_components=("${RPI_THEME_COMPONENTS[@]}" "${RPI_LOGGER_THEME_COMPONENTS[@]}" "THEME_NC")
  local component

  for component in "${all_theme_components[@]}"; do
    printf -v "MOCKED_${component}_COLOUR" '%s' "MOCKED_STDLIB_${component}_COLOUR_VALUE"
  done
}

# shellcheck disable=SC2034
_fixture_mocked_complete_theme_logger() {
  THEME_LOGGER_ERROR="RED"
  THEME_LOGGER_WARNING="YELLOW"
  THEME_LOGGER_INFO="WHITE"
  THEME_LOGGER_NOTICE="GREY"
  THEME_LOGGER_SUCCESS="GREEN"

  for theme_component in "${RPI_LOGGER_THEME_COMPONENTS[@]}"; do
    printf -v "ORIGINAL_${theme_component}" "%s" "${!theme_component}"
  done
}

_fixture_mocked_incomplete_theme_logger() {
  _fixture_mocked_complete_theme_logger

  unset THEME_LOGGER_NOTICE
  unset ORIGINAL_THEME_LOGGER_NOTICE
}

_fixture_mocked_incomplete_theme() {
  _fixture_mocked_complete_theme

  unset "MOCKED_${RPI_THEME_COMPONENTS[2]}_COLOUR"
}

_fixture_mocked_valid_colours() {
  _mock.create stdlib.setting.theme.get_colour

  stdlib.setting.theme.get_colour.mock.set.subcommand \
    "echo \"MOCKED_\${RPI_THEME_COMPONENT}_COLOUR\""
}

_fixture_one_invalid_colour() {
  _mock.create stdlib.setting.theme.get_colour

  stdlib.setting.theme.get_colour.mock.set.subcommand "
    [[ \"\${RPI_THEME_COMPONENT}\" == \"\${RPI_THEME_COMPONENTS[1]}\" ]] && return 1 ||
    { echo \"MOCKED_\${RPI_THEME_COMPONENT}_COLOUR\"; return 0; }
"
}
