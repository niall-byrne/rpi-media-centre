#!/bin/bash
# shellcheck disable=SC2034

# stdlib colour enabled library

builtin set -eo pipefail

STDLIB_COLOUR_NC="$(tput sgr0)"
STDLIB_COLOUR_BLACK="$(
  tput sgr0
  tput setaf 0
)"
STDLIB_COLOUR_RED="$(
  tput sgr0
  tput setaf 1
)"
STDLIB_COLOUR_GREEN="$(
  tput sgr0
  tput setaf 2
)"
STDLIB_COLOUR_YELLOW="$(
  tput sgr0
  tput setaf 3
)"
STDLIB_COLOUR_BLUE="$(
  tput sgr0
  tput setaf 4
)"
STDLIB_COLOUR_PURPLE="$(
  tput sgr0
  tput setaf 5
)"
STDLIB_COLOUR_CYAN="$(
  tput sgr0
  tput setaf 6
)"
STDLIB_COLOUR_WHITE="$(
  tput sgr0
  tput setaf 7
)"
STDLIB_COLOUR_GREY="$(
  tput sgr0
  tput setaf 0 bold
)"
STDLIB_COLOUR_LIGHT_RED="$(
  tput sgr0
  tput setaf 1 bold
)"
STDLIB_COLOUR_LIGHT_GREEN="$(
  tput sgr0
  tput setaf 2 bold
)"
STDLIB_COLOUR_LIGHT_YELLOW="$(
  tput sgr0
  tput setaf 3 bold
)"
STDLIB_COLOUR_LIGHT_BLUE="$(
  tput sgr0
  tput setaf 4 bold
)"
STDLIB_COLOUR_LIGHT_PURPLE="$(
  tput sgr0
  tput setaf 5 bold
)"
STDLIB_COLOUR_LIGHT_CYAN="$(
  tput sgr0
  tput setaf 6 bold
)"
STDLIB_COLOUR_LIGHT_WHITE="$(
  tput sgr0
  tput setaf 7 bold
)"
