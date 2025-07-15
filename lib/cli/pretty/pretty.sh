#!/bin/bash

# pictl cli pretty library

set -eo pipefail

__cli_pretty_brackets() {
  # $1: the bracket colour
  # $2: the inside bracket colour
  # $3: the opening bracket character set
  # $4: the closing bracket character set
  # $5: the input string to colourize

  local RPI_CLI_PRETTY_BRACKET_BOOLEAN="0"
  local RPI_CLI_PRETTY_INDEX="0"
  local RPI_CLI_PRETTY_INPUT=""
  local RPI_CLI_PRETTY_OUTPUT=""

  RPI_CLI_PRETTY_INPUT="${5}"

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
        RPI_CLI_PRETTY_OUTPUT+="${THEME_NC}"
        RPI_CLI_PRETTY_BRACKET_BOOLEAN="0"
        continue
      fi
    fi

    RPI_CLI_PRETTY_OUTPUT+="${RPI_CLI_PRETTY_CHAR}"
  done

  echo -e "${RPI_CLI_PRETTY_OUTPUT}"
}

_cli_pretty_brackets_style_1() {
  # $1: the input string to colourize

  __cli_pretty_brackets \
    "${THEME_BRACKETS_STYLE_1}" \
    "${THEME_BRACKETS_STYLE_1_INNER}" \
    "[(" "])" \
    "${1}"
}

_io_make_pipeable "_cli_pretty_brackets_style_1" "1"

_cli_pretty_brackets_style_2() {
  # $1: the input string to colourize

  __cli_pretty_brackets \
    "${THEME_BRACKETS_STYLE_2}" \
    "${THEME_BRACKETS_STYLE_2_INNER}" \
    "[(" "])" \
    "${1}"
}

_io_make_pipeable "_cli_pretty_brackets_style_2" "1"

_cli_pretty_bullet_point() {
  # $1: the input string to colourize
  # $2: an optional indent size

  if [[ "${2}" =~ [0-9]+ ]]; then
    printf "%*s" "${2}" " "
  fi

  echo -e "- ${THEME_ENTITY}${1}${THEME_NC}"
}

_io_make_pipeable "_cli_pretty_bullet_point" "1"

_cli_pretty_columns() {
  # $1: the input string to colourize

  local CONTENT_LINE
  local RPI_CLI_PRETTY_COLUMN_1=""
  local RPI_CLI_PRETTY_COLUMN_2=""

  while IFS= read -r CONTENT_LINE; do
    IFS="|" read -r \
      RPI_CLI_PRETTY_COLUMN_1 \
      RPI_CLI_PRETTY_COLUMN_2 \
      <<< "${CONTENT_LINE}"

    RPI_CLI_PRETTY_COLUMN_1="${RPI_CLI_PRETTY_COLUMN_1//\`/}"
    _cli_pretty_justify_left_var "${RPI_CLI_COLUMN_ALIGNMENT_WITHOUT_TAB}" "RPI_CLI_PRETTY_COLUMN_1"
    _cli_pretty_colour_n "ENTITY" "${RPI_CLI_PRETTY_COLUMN_1}"
    _cli_pretty_wrap_column "${RPI_CLI_COLUMN_ALIGNMENT_WITHOUT_TAB}" 100 "- ${RPI_CLI_PRETTY_COLUMN_2}" |
      _cli_pretty_quotes '`' ''
  done <<< "${1}"
}

_io_make_pipeable "_cli_pretty_columns" "1"

_cli_pretty_detail() {
  # $1: the input string to colourize

  _cli_pretty_colour "DETAIL" "${1}"
}

_io_make_pipeable "_cli_pretty_detail" "1"

_cli_pretty_entity() {
  # $1: the input string to colourize

  _cli_pretty_colour "ENTITY" "${1}"
}

_io_make_pipeable "_cli_pretty_entity" "1"

_cli_pretty_env_var() {
  # $1: the input string to colourize

  echo -en "${1}" |
    sed 's,\([A-Z0-9_]*\)=,'"${THEME_ENTITY}"'\1'"${THEME_NC}="',g' |
    _cli_pretty_quotes '"' '"'
}

_io_make_pipeable "_cli_pretty_env_var" "1"

_cli_pretty_header() {
  # $1: the input string to colourize

  _cli_pretty_colour "HEADER" "${1}"
}

_io_make_pipeable "_cli_pretty_header" "1"

_cli_pretty_highlight() {
  # $1: the input string to colourize

  _cli_pretty_colour "HIGHLIGHT" "${1}"
}

_io_make_pipeable "_cli_pretty_highlight" "1"

_cli_pretty_info() {

  _cli_pretty_colour "INFO" "${1}"
}

_io_make_pipeable "_cli_pretty_info" "1"

_cli_pretty_markdown_link() {
  # #1: the text to modify

  local RPI_CLI_PRETTY_INPUT=""
  local RPI_CLI_PRETTY_LINE=""
  local RPI_CLI_PRETTY_MARKDOWN_REGEX=".*(\\[(.*?)\\]\\(.*\\)).*$"
  local RPI_CLI_PRETTY_OUTPUT=""
  local RPI_CLI_PRETTY_REGEX_GREEDY_FIX=""

  RPI_CLI_PRETTY_INPUT="${1}"

  while IFS= read -r RPI_CLI_PRETTY_LINE; do
    if [[ "${RPI_CLI_PRETTY_LINE}" =~ ${RPI_CLI_PRETTY_MARKDOWN_REGEX} ]]; then
      IFS=")" read -r RPI_CLI_PRETTY_REGEX_GREEDY_FIX _ <<< "${BASH_REMATCH[1]}"
      RPI_CLI_PRETTY_LINE="${RPI_CLI_PRETTY_LINE/"${RPI_CLI_PRETTY_REGEX_GREEDY_FIX})"/"${BASH_REMATCH[2]}"}"
    fi

    echo -e "${RPI_CLI_PRETTY_LINE}"
  done <<< "${RPI_CLI_PRETTY_INPUT}"
}

_io_make_pipeable "_cli_pretty_markdown_link" "1"

_cli_pretty_numbers() {
  # $1: the input string to colourize

  printf "%b"$'\n' "${1}" |
    sed 's,\([0-9][0-9]*\),'"${THEME_ENTITY}\\1${THEME_NC}"',g'
}

_io_make_pipeable "_cli_pretty_numbers" "1"

_cli_pretty_quotes() {
  # #1: the quote character
  # $2: a replacement character to insert
  # $3: the input string to colourize

  local RPI_CLI_PRETTY_CHAR=""
  local RPI_CLI_PRETTY_INDEX="0"
  local RPI_CLI_PRETTY_INPUT=""
  local RPI_CLI_PRETTY_OUTPUT=""
  local RPI_CLI_PRETTY_QUOTE_BOOLEAN="0"

  RPI_CLI_PRETTY_INPUT="${3}"

  for ((RPI_CLI_PRETTY_INDEX = 0; RPI_CLI_PRETTY_INDEX < "${#RPI_CLI_PRETTY_INPUT}"; RPI_CLI_PRETTY_INDEX++)); do

    RPI_CLI_PRETTY_CHAR="${RPI_CLI_PRETTY_INPUT:${RPI_CLI_PRETTY_INDEX}:1}"

    if [[ "${RPI_CLI_PRETTY_CHAR}" == "${1}" ]]; then
      if [[ "${RPI_CLI_PRETTY_QUOTE_BOOLEAN}" -eq "0" ]]; then
        RPI_CLI_PRETTY_OUTPUT+="${2}${THEME_QUOTES}"
        RPI_CLI_PRETTY_QUOTE_BOOLEAN="1"
      else
        RPI_CLI_PRETTY_OUTPUT+="${THEME_NC}${2}"
        RPI_CLI_PRETTY_QUOTE_BOOLEAN="0"
      fi
    else
      RPI_CLI_PRETTY_OUTPUT+="${RPI_CLI_PRETTY_CHAR}"
    fi
  done

  echo -e "${RPI_CLI_PRETTY_OUTPUT}"
}

_io_make_pipeable "_cli_pretty_quotes" "3"

_cli_pretty_title() {
  # $1: the input string to colourize
  _cli_pretty_colour "TITLE" "${1}"
}

_io_make_pipeable "_cli_pretty_title" "1"

_io_make_var_function "_cli_pretty_title"
