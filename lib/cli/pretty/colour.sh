#!/bin/bash

# pictl cli pretty colour library

set -eo pipefail

_cli_pretty_colour_n() {
  # $1: the theme colour
  # $2: the source string

  local RPI_CLI_PRETTY_THEME_COLOUR

  RPI_CLI_PRETTY_THEME_COLOUR="THEME_${1}"

  echo -ne "${!RPI_CLI_PRETTY_THEME_COLOUR}${2}${THEME_NC}"
}

stdlib.fn.derive.pipeable "_cli_pretty_colour_n" "2"

stdlib.fn.derive.var "_cli_pretty_colour_n" "_cli_pretty_colour_var"

_cli_pretty_colour() {
  # $1: the theme colour
  # $2: the source string

  local RPI_CLI_PRETTY_THEME_COLOUR

  RPI_CLI_PRETTY_THEME_COLOUR="THEME_${1}"

  echo -e "${!RPI_CLI_PRETTY_THEME_COLOUR}${2}${THEME_NC}"
}

stdlib.fn.derive.pipeable "_cli_pretty_colour" "2"

_cli_pretty_colour_substring() {
  # $1: the theme colour
  # $2: the substring to highlight
  # $3: the source string

  local RPI_CLI_PRETTY_THEME_COLOUR

  RPI_CLI_PRETTY_THEME_COLOUR="THEME_${1}"

  echo -e "${3/${2}/${!RPI_CLI_PRETTY_THEME_COLOUR}${2}${THEME_NC}}"
}

stdlib.fn.derive.pipeable "_cli_pretty_colour_substring" "3"

stdlib.fn.derive.var "_cli_pretty_colour_substring"

_cli_pretty_colour_substrings() {
  # $1: the theme colour
  # $2: the substring to highlight
  # $3: the source string

  local RPI_CLI_PRETTY_THEME_COLOUR

  RPI_CLI_PRETTY_THEME_COLOUR="THEME_${1}"

  echo -e "${3//${2}/${!RPI_CLI_PRETTY_THEME_COLOUR}${2}${THEME_NC}}"
}

stdlib.fn.derive.pipeable "_cli_pretty_colour_substrings" "3"

stdlib.fn.derive.var "_cli_pretty_colour_substrings"
