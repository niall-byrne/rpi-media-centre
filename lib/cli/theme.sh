#!/bin/bash
# shellcheck disable=SC2034

# pictl cli theme library

set -eo pipefail

RPI_COLOUR_NC="$(tput sgr0)"
RPI_COLOUR_BLACK="$(
  tput sgr0
  tput setaf 0
)"
RPI_COLOUR_RED="$(
  tput sgr0
  tput setaf 1
)"
RPI_COLOUR_GREEN="$(
  tput sgr0
  tput setaf 2
)"
RPI_COLOUR_YELLOW="$(
  tput sgr0
  tput setaf 3
)"
RPI_COLOUR_BLUE="$(
  tput sgr0
  tput setaf 4
)"
RPI_COLOUR_PURPLE="$(
  tput sgr0
  tput setaf 5
)"
RPI_COLOUR_CYAN="$(
  tput sgr0
  tput setaf 6
)"
RPI_COLOUR_WHITE="$(
  tput sgr0
  tput setaf 7
)"
RPI_COLOUR_GRAY="$(
  tput sgr0
  tput setaf 0 bold
)"
RPI_COLOUR_LIGHT_RED="$(
  tput sgr0
  tput setaf 1 bold
)"
RPI_COLOUR_LIGHT_GREEN="$(
  tput sgr0
  tput setaf 2 bold
)"
RPI_COLOUR_LIGHT_YELLOW="$(
  tput sgr0
  tput setaf 3 bold
)"
RPI_COLOUR_LIGHT_BLUE="$(
  tput sgr0
  tput setaf 4 bold
)"
RPI_COLOUR_LIGHT_PURPLE="$(
  tput sgr0
  tput setaf 5 bold
)"
RPI_COLOUR_LIGHT_CYAN="$(
  tput sgr0
  tput setaf 6 bold
)"
RPI_COLOUR_LIGHT_WHITE="$(
  tput sgr0
  tput setaf 7 bold
)"
