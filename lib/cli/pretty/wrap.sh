#!/bin/bash

# pictl cli pretty wrap library

set -eo pipefail

_cli_pretty_wrap_column() {
  # $1: the left-side padding
  # $2: the right-side wrap limit
  # $3: the text to wrap

  local RPI_CLI_PRETTY_INPUT
  local RPI_CLI_PRETTY_WRAP_ARRAY=()
  local RPI_CLI_PRETTY_WRAP_PRETTIFIED_STRING=""
  local RPI_CLI_PRETTY_WRAP_STRING=""
  local RPI_CLI_PRETTY_WRAP_STRING_LENGTH=0
  local RPI_CLI_PRETTY_WRAP_WORD=""
  local RPI_CLI_PRETTY_WRAP_WORD_BUFFER=""
  local RPI_CLI_PRETTY_WRAP_WORD_LENGTH=0

  RPI_CLI_PRETTY_INPUT="${3}"

  read -ra RPI_CLI_PRETTY_WRAP_ARRAY <<< "${RPI_CLI_PRETTY_INPUT}"

  for RPI_CLI_PRETTY_WRAP_WORD in "${RPI_CLI_PRETTY_WRAP_ARRAY[@]}"; do
    RPI_CLI_PRETTY_WRAP_STRING_LENGTH="${#RPI_CLI_PRETTY_WRAP_STRING}"
    RPI_CLI_PRETTY_WRAP_WORD_LENGTH="${#RPI_CLI_PRETTY_WRAP_STRING_LENGTH}"

    if _cli_pretty_string_first_char_is "*" "${RPI_CLI_PRETTY_WRAP_WORD}"; then
      RPI_CLI_PRETTY_WRAP_WORD_BUFFER="${RPI_CLI_PRETTY_WRAP_WORD:1} "
      RPI_CLI_PRETTY_WRAP_STRING="${RPI_CLI_PRETTY_WRAP_WORD_BUFFER}"
      _cli_pretty_pad_left_var "${1}" "RPI_CLI_PRETTY_WRAP_WORD_BUFFER"
      RPI_CLI_PRETTY_WRAP_PRETTIFIED_STRING+="\n  ${RPI_CLI_PRETTY_WRAP_WORD_BUFFER}"
      continue
    fi

    if (("$((RPI_CLI_PRETTY_WRAP_STRING_LENGTH + RPI_CLI_PRETTY_WRAP_WORD_LENGTH))" <= "${2}" - "${1}")); then
      RPI_CLI_PRETTY_WRAP_STRING+="${RPI_CLI_PRETTY_WRAP_WORD} "
      RPI_CLI_PRETTY_WRAP_PRETTIFIED_STRING+="${RPI_CLI_PRETTY_WRAP_WORD} "
    else
      RPI_CLI_PRETTY_WRAP_STRING="${RPI_CLI_PRETTY_WRAP_WORD} "
      _cli_pretty_pad_left_var "${1}" "RPI_CLI_PRETTY_WRAP_WORD"
      RPI_CLI_PRETTY_WRAP_PRETTIFIED_STRING+="\n  ${RPI_CLI_PRETTY_WRAP_WORD} "
    fi
  done

  echo -e "$RPI_CLI_PRETTY_WRAP_PRETTIFIED_STRING"
}

_io_make_pipeable "_cli_pretty_wrap_column" "3"
