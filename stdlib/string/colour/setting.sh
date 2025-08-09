#!/bin/bash
# shellcheck disable=SC2034

# stdlib string colour setting library

set -eo pipefail

STDLIB_COLOUR_NC="$(tput sgr0)"
STDLIB_COLOUR_BLACK="$(
  #:nocov:
  # bashcov doesn't report this section correctly
  tput sgr0
  tput setaf 0
  #:nocov:
)"
STDLIB_COLOUR_RED="$(
  #:nocov:
  # bashcov doesn't report this section correctly
  tput sgr0
  tput setaf 1
  #:nocov:
)"
STDLIB_COLOUR_GREEN="$(
  #:nocov:
  # bashcov doesn't report this section correctly
  tput sgr0
  tput setaf 2
  #:nocov:
)"
STDLIB_COLOUR_YELLOW="$(
  #:nocov:
  # bashcov doesn't report this section correctly
  tput sgr0
  tput setaf 3
  #:nocov:
)"
STDLIB_COLOUR_BLUE="$(
  #:nocov:
  # bashcov doesn't report this section correctly
  tput sgr0
  tput setaf 4
  #:nocov:
)"
STDLIB_COLOUR_PURPLE="$(
  #:nocov:
  # bashcov doesn't report this section correctly
  tput sgr0
  tput setaf 5
  #:nocov:
)"
STDLIB_COLOUR_CYAN="$(
  #:nocov:
  # bashcov doesn't report this section correctly
  tput sgr0
  tput setaf 6
  #:nocov:
)"
STDLIB_COLOUR_WHITE="$(
  #:nocov:
  # bashcov doesn't report this section correctly
  tput sgr0
  tput setaf 7
  #:nocov:
)"
STDLIB_COLOUR_GREY="$(
  #:nocov:
  # bashcov doesn't report this section correctly
  tput sgr0
  tput setaf 0 bold
  #:nocov:
)"
STDLIB_COLOUR_LIGHT_RED="$(
  #:nocov:
  # bashcov doesn't report this section correctly
  tput sgr0
  tput setaf 1 bold
  #:nocov:
)"
STDLIB_COLOUR_LIGHT_GREEN="$(
  #:nocov:
  # bashcov doesn't report this section correctly
  tput sgr0
  tput setaf 2 bold
  #:nocov:
)"
STDLIB_COLOUR_LIGHT_YELLOW="$(
  #:nocov:
  # bashcov doesn't report this section correctly
  tput sgr0
  tput setaf 3 bold
  #:nocov:
)"
STDLIB_COLOUR_LIGHT_BLUE="$(
  #:nocov:
  # bashcov doesn't report this section correctly
  tput sgr0
  tput setaf 4 bold
  #:nocov:
)"
STDLIB_COLOUR_LIGHT_PURPLE="$(
  #:nocov:
  # bashcov doesn't report this section correctly
  tput sgr0
  tput setaf 5 bold
  #:nocov:
)"
STDLIB_COLOUR_LIGHT_CYAN="$(
  #:nocov:
  # bashcov doesn't report this section correctly
  tput sgr0
  tput setaf 6 bold
  #:nocov:
)"
STDLIB_COLOUR_LIGHT_WHITE="$(
  #:nocov:
  # bashcov doesn't report this section correctly
  tput sgr0
  tput setaf 7 bold
  #:nocov:
)"
