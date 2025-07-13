#!/bin/bash

# pictl cli pretty library

set -eo pipefail

_cli_pretty_block_devices() {
  # $1: the input string to colourize

  local CONTENT_LINE
  local RPI_CLI_PRETTY_INPUT
  local RPI_CLI_PRETTY_DEVICE_REGX="(\/dev\/[a-z]{3}):"

  RPI_CLI_PRETTY_INPUT="$(_io_make_pipeable "${1}")"

  while IFS= read -r CONTENT_LINE; do

    if [[ "${CONTENT_LINE}" =~ ${RPI_CLI_PRETTY_DEVICE_REGX} ]]; then
      CONTENT_LINE="${CONTENT_LINE//"${BASH_REMATCH[1]}"/"${COLOUR_GRAY}${BASH_REMATCH[1]}${COLOUR_NC}"}"
    fi

    echo -e "${CONTENT_LINE}"
  done <<< "${RPI_CLI_PRETTY_INPUT}"
}

_cli_pretty_block_devices_status() {
  # $1: the input string to colourize

  local CONTENT_LINE
  local RPI_CLI_PRETTY_INPUT
  local RPI_CLI_PRETTY_ACTIVE="active/idle"
  local RPI_CLI_PRETTY_STANDBY="standby"

  RPI_CLI_PRETTY_INPUT="$(_io_make_pipeable "${1}")"

  while IFS= read -r CONTENT_LINE; do

    case "${CONTENT_LINE}" in
      *"${RPI_CLI_PRETTY_ACTIVE}"*)
        CONTENT_LINE="${CONTENT_LINE//"${RPI_CLI_PRETTY_ACTIVE}"/"${COLOUR_YELLOW}${RPI_CLI_PRETTY_ACTIVE}${COLOUR_NC}"}"
        ;;
      *"${RPI_CLI_PRETTY_STANDBY}"*)
        CONTENT_LINE="${CONTENT_LINE//"${RPI_CLI_PRETTY_STANDBY}"/"${COLOUR_GRAY}${RPI_CLI_PRETTY_STANDBY}${COLOUR_NC}"}"
        ;;
    esac

    echo -e "${CONTENT_LINE}"
  done <<< "${RPI_CLI_PRETTY_INPUT}"
}

_cli_pretty_block_devices_mappings() {
  # $1: the input string to colourize

  local CONTENT_LINE
  local RPI_CLI_PRETTY_INPUT
  local RPI_CLI_PRETTY_TITLE_BOOLEAN="0"
  local RPI_CLI_PRETTY_DEVICE_REGEX="^( *└─*|├─*|)([a-z0-9_]*)"
  local RPI_CLI_PRETTY_FREE_REGEX="([0-9]+\.[0-9]+[GKMT]+)"
  local RPI_CLI_PRETTY_PERCENT_REGEX="([0-9]+)%"

  RPI_CLI_PRETTY_INPUT="$(_io_make_pipeable "${1}")"

  while IFS= read -r CONTENT_LINE; do

    if [[ "${RPI_CLI_PRETTY_TITLE_BOOLEAN}" == "0" ]]; then
      CONTENT_LINE="$(_cli_pretty_header "${CONTENT_LINE}")"
      RPI_CLI_PRETTY_TITLE_BOOLEAN="1"
    fi

    if [[ "${CONTENT_LINE}" =~ ${RPI_CLI_PRETTY_DEVICE_REGEX} ]]; then
      CONTENT_LINE="${CONTENT_LINE/"${BASH_REMATCH[1]}"/"${COLOUR_GRAY}${BASH_REMATCH[1]}${COLOUR_NC}"}"
      CONTENT_LINE="${CONTENT_LINE/"${BASH_REMATCH[2]}"/"${COLOUR_LIGHT_BLUE}${BASH_REMATCH[2]}${COLOUR_NC}"}"
    fi

    if [[ "${CONTENT_LINE}" =~ ${RPI_CLI_PRETTY_FREE_REGEX} ]]; then
      CONTENT_LINE="${CONTENT_LINE/"${BASH_REMATCH[1]}"/"${COLOUR_GRAY}${BASH_REMATCH[1]}${COLOUR_NC}"}"
    fi

    if [[ "${CONTENT_LINE}" =~ ${RPI_CLI_PRETTY_PERCENT_REGEX} ]]; then
      if (("${BASH_REMATCH[1]}" >= "90")); then
        CONTENT_LINE="${CONTENT_LINE//"${BASH_REMATCH[1]}%"/"${COLOUR_RED}${BASH_REMATCH[1]}%${COLOUR_NC}"}"
      elif (("${BASH_REMATCH[1]}" >= "66")); then
        CONTENT_LINE="${CONTENT_LINE//"${BASH_REMATCH[1]}%"/"${COLOUR_YELLOW}${BASH_REMATCH[1]}%${COLOUR_NC}"}"
      else
        CONTENT_LINE="${CONTENT_LINE//"${BASH_REMATCH[1]}%"/"${COLOUR_GREEN}${BASH_REMATCH[1]}%${COLOUR_NC}"}"
      fi
    fi

    echo -e "${CONTENT_LINE}"
  done <<< "${RPI_CLI_PRETTY_INPUT}"
}

_cli_pretty_brackets() {
  # $1: the bracket colour
  # $2: the inside bracket colour
  # $3: the opening bracket character set
  # $4: the closing bracket character set
  # $5: the input string to colourize

  local RPI_CLI_PRETTY_BRACKET_BOOLEAN="0"
  local RPI_CLI_PRETTY_INDEX="0"
  local RPI_CLI_PRETTY_INPUT=""
  local RPI_CLI_PRETTY_OUTPUT=""

  RPI_CLI_PRETTY_INPUT="$(_io_make_pipeable "${5}")"

  for ((RPI_CLI_PRETTY_INDEX = 0; RPI_CLI_PRETTY_INDEX < "${#RPI_CLI_PRETTY_INPUT}"; RPI_CLI_PRETTY_INDEX++)); do

    RPI_CLI_PRETTY_CHAR="${RPI_CLI_PRETTY_INPUT:${RPI_CLI_PRETTY_INDEX}:1}"

    if [[ "${3}" == *"${RPI_CLI_PRETTY_CHAR}"* ]]; then
      if [[ "${RPI_CLI_PRETTY_BRACKET_BOOLEAN}" -eq "0" ]]; then
        RPI_CLI_PRETTY_OUTPUT+="${1}"
        RPI_CLI_PRETTY_OUTPUT+="${RPI_CLI_PRETTY_CHAR}"
        RPI_CLI_PRETTY_OUTPUT+="${2}"
        RPI_CLI_PRETTY_BRACKET_BOOLEAN="1"
        continue
      fi
    fi

    if [[ "${4}" == *"${RPI_CLI_PRETTY_CHAR}"* ]]; then
      if [[ "${RPI_CLI_PRETTY_BRACKET_BOOLEAN}" -eq "1" ]]; then
        RPI_CLI_PRETTY_OUTPUT+="${1}"
        RPI_CLI_PRETTY_OUTPUT+="${RPI_CLI_PRETTY_CHAR}"
        RPI_CLI_PRETTY_OUTPUT+="${COLOUR_NC}"
        RPI_CLI_PRETTY_BRACKET_BOOLEAN="0"
        continue
      fi
    fi

    RPI_CLI_PRETTY_OUTPUT+="${RPI_CLI_PRETTY_CHAR}"
  done

  echo -e "${RPI_CLI_PRETTY_OUTPUT}"
}

_cli_pretty_brackets_style_1() {
  # $1: the bracket colour
  # $2: the inside bracket colour
  # $3: the input string to colourize

  _cli_pretty_brackets "${1}" "${2}" "[(" "])" "${3}"
}

_cli_pretty_columns() {
  # $1: the input string to colourize

  local CONTENT_LINE
  local RPI_CLI_PRETTY_COLUMN_1=""
  local RPI_CLI_PRETTY_COLUMN_2=""
  local RPI_CLI_PRETTY_INPUT=""

  RPI_CLI_PRETTY_INPUT="$(_io_make_pipeable "${1}")"

  while IFS= read -r CONTENT_LINE; do
    IFS="|" read -r \
      RPI_CLI_PRETTY_COLUMN_1 \
      RPI_CLI_PRETTY_COLUMN_2 \
      <<< "${CONTENT_LINE}"

    RPI_CLI_PRETTY_COLUMN_1="$(printf "%-${RPI_CLI_COLUMN_ALIGNMENT_WITHOUT_TAB}s" "${RPI_CLI_PRETTY_COLUMN_1//\`/}")"
    echo -en "${COLOUR_LIGHT_BLUE}${RPI_CLI_PRETTY_COLUMN_1}${COLOUR_NC}"
    _cli_pretty_wrap "- ${RPI_CLI_PRETTY_COLUMN_2}" "${RPI_CLI_COLUMN_ALIGNMENT_WITHOUT_TAB}" 100 |
      _cli_pretty_quotes '`' ''
  done <<< "${RPI_CLI_PRETTY_INPUT}"
}

_cli_pretty_envar() {
  # $1: the input string to colourize

  local RPI_CLI_PRETTY_INPUT=""

  RPI_CLI_PRETTY_INPUT="$(_io_make_pipeable "${1}")"

  echo -en "${RPI_CLI_PRETTY_INPUT}" |
    sed 's,\([A-Z0-9_]*\)=,'"${COLOUR_RED}"'\1'"${COLOUR_NC}="',g' |
    _cli_pretty_quotes '"' '"'
}

_cli_pretty_header() {
  # $1: the input string to colourize

  echo -e "${COLOUR_CYAN}${1}${COLOUR_NC}"
}

_cli_pretty_highlight() {
  # $1: the input string to colourize

  echo -e "${COLOUR_LIGHT_RED}${1}${COLOUR_NC}"
}

_cli_pretty_markdown() {
  # #1: the text to modify

  local RPI_CLI_PRETTY_INPUT=""
  local RPI_CLI_PRETTY_LINE=""
  local RPI_CLI_PRETTY_MARKDOWN_REGEX=".*(\\[(.*?)\\]\\(.*\\)).*$"
  local RPI_CLI_PRETTY_OUTPUT=""
  local RPI_CLI_PRETTY_REGEX_GREEDY_FIX=""

  RPI_CLI_PRETTY_INPUT="$(_io_make_pipeable "${1}")"

  while IFS= read -r RPI_CLI_PRETTY_LINE; do
    if [[ "${RPI_CLI_PRETTY_LINE}" =~ ${RPI_CLI_PRETTY_MARKDOWN_REGEX} ]]; then
      IFS=")" read -r RPI_CLI_PRETTY_REGEX_GREEDY_FIX _ <<< "${BASH_REMATCH[1]}"
      RPI_CLI_PRETTY_LINE="${RPI_CLI_PRETTY_LINE/"${RPI_CLI_PRETTY_REGEX_GREEDY_FIX})"/"${BASH_REMATCH[2]}"}"
    fi

    echo -e "${RPI_CLI_PRETTY_LINE}"
  done <<< "${RPI_CLI_PRETTY_INPUT}"
}

_cli_pretty_numbers() {
  # $1: the input string to colourize

  printf "%b" "${1}" |
    sed 's,\([0-9]*\),'"${COLOUR_LIGHT_BLUE}\\1${COLOUR_NC}"',g'
}

_cli_pretty_quotes() {
  # #1: the quote character
  # $2: a replacement character to insert
  # $3: the input string to colourize

  local RPI_CLI_PRETTY_CHAR=""
  local RPI_CLI_PRETTY_INDEX="0"
  local RPI_CLI_PRETTY_INPUT=""
  local RPI_CLI_PRETTY_OUTPUT=""
  local RPI_CLI_PRETTY_QUOTE_BOOLEAN="0"

  RPI_CLI_PRETTY_INPUT="$(_io_make_pipeable "${3}")"

  for ((RPI_CLI_PRETTY_INDEX = 0; RPI_CLI_PRETTY_INDEX < "${#RPI_CLI_PRETTY_INPUT}"; RPI_CLI_PRETTY_INDEX++)); do

    RPI_CLI_PRETTY_CHAR="${RPI_CLI_PRETTY_INPUT:${RPI_CLI_PRETTY_INDEX}:1}"

    if [[ "${RPI_CLI_PRETTY_CHAR}" == "${1}" ]]; then
      if [[ "${RPI_CLI_PRETTY_QUOTE_BOOLEAN}" -eq "0" ]]; then
        RPI_CLI_PRETTY_OUTPUT+="${2}${COLOUR_GRAY}"
        RPI_CLI_PRETTY_QUOTE_BOOLEAN="1"
      else
        RPI_CLI_PRETTY_OUTPUT+="${COLOUR_NC}${2}"
        RPI_CLI_PRETTY_QUOTE_BOOLEAN="0"
      fi
    else
      RPI_CLI_PRETTY_OUTPUT+="${RPI_CLI_PRETTY_CHAR}"
    fi
  done

  echo -e "${RPI_CLI_PRETTY_OUTPUT}"
}

_cli_pretty_title() {
  # $1: the input string to colourize

  echo -e "${COLOUR_LIGHT_GREEN}${1}${COLOUR_NC}"
}

_cli_pretty_wrap() {
  # $1: the text to wrap
  # $2: the left-side padding
  # $3: the right-side width limit

  local RPI_CLI_PRETTY_WRAP_ARRAY=()
  local RPI_CLI_PRETTY_WRAP_PRETTIFIED_STRING=""
  local RPI_CLI_PRETTY_WRAP_STRING=""
  local RPI_CLI_PRETTY_WRAP_STRING_LENGTH=0
  local RPI_CLI_PRETTY_WRAP_WORD=""
  local RPI_CLI_PRETTY_WRAP_WORD_LENGTH=0

  read -ra RPI_CLI_PRETTY_WRAP_ARRAY <<< "${1}"

  for RPI_CLI_PRETTY_WRAP_WORD in "${RPI_CLI_PRETTY_WRAP_ARRAY[@]}"; do
    RPI_CLI_PRETTY_WRAP_STRING_LENGTH="${#RPI_CLI_PRETTY_WRAP_STRING}"
    RPI_CLI_PRETTY_WRAP_WORD_LENGTH="${#RPI_CLI_PRETTY_WRAP_STRING_LENGTH}"

    if [[ "${RPI_CLI_PRETTY_WRAP_WORD:0:1}" == "*" ]]; then
      RPI_CLI_PRETTY_WRAP_STRING="${RPI_CLI_PRETTY_WRAP_WORD:1} "
      RPI_CLI_PRETTY_WRAP_PRETTIFIED_STRING+="\n  $(printf '%*s' "${2}" " ")${RPI_CLI_PRETTY_WRAP_WORD:1} "
      continue
    fi

    if (("${3}" >= "$(("${2}" + RPI_CLI_PRETTY_WRAP_STRING_LENGTH + RPI_CLI_PRETTY_WRAP_WORD_LENGTH))")); then
      RPI_CLI_PRETTY_WRAP_STRING+="${RPI_CLI_PRETTY_WRAP_WORD} "
      RPI_CLI_PRETTY_WRAP_PRETTIFIED_STRING+="${RPI_CLI_PRETTY_WRAP_WORD} "
    else
      RPI_CLI_PRETTY_WRAP_STRING="${RPI_CLI_PRETTY_WRAP_WORD} "
      RPI_CLI_PRETTY_WRAP_PRETTIFIED_STRING+="\n  $(printf '%*s' "${2}" " ")${RPI_CLI_PRETTY_WRAP_WORD} "
    fi
  done

  echo -e "$RPI_CLI_PRETTY_WRAP_PRETTIFIED_STRING"
}
