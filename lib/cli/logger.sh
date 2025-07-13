#!/bin/bash

# pictl cli logger library

set -eo pipefail

_cli_log_error() {
  # $1: the input string to colourize

  {
    echo -e "${COLOUR_LIGHT_RED}${1}${COLOUR_NC}"
  } >&2
}

_cli_log_info() {
  # $1: the input string to colourize

  echo -e "${COLOUR_WHITE}${1}${COLOUR_NC}"
}

_cli_log_notice() {
  # $1: the input string to colourize

  echo -e "${COLOUR_GRAY}${1}${COLOUR_NC}"
}

_cli_log_success() {
  # $1: the input string to colourize

  echo -e "${COLOUR_GREEN}${1}${COLOUR_NC}"
}

_cli_log_warning() {
  # $1: the input string to colourize

  {
    echo -e "${COLOUR_YELLOW}${1}${COLOUR_NC}"
  } >&2
}
