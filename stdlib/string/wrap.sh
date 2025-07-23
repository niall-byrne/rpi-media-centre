#!/bin/bash

# stdlib string wrap library

set -eo pipefail

stdlib.string.wrap() {
  # $1: the left-side padding
  # $2: the right-side wrap limit
  # $3: the text to wrap
  #
  # _LINE_BREAK_CHAR: force a line break in the text

  local forced_line_break_char="${_LINE_BREAK_CHAR:-*}"

  local current_line=""
  local current_line_length=0
  local current_word=""
  local current_word_length=0
  local input_array=()
  local output=""
  local wrap_limit=0

  stdlib.fn.args.require "3" "0" "${@}" || return "$?"
  stdlib.string.assert.is_digit "${1}" || return 126
  stdlib.string.assert.is_digit "${2}" || return 126

  wrap_limit="$(("${2}" - "${1}"))"
  read -ra input_array <<< "${3}"

  for current_word in "${input_array[@]}"; do
    current_line_length="${#current_line}"
    current_word_length="${#current_word}"

    if stdlib.string.query.first_char_is "${forced_line_break_char}" "${current_word}"; then
      #:nocov:
      # bashcov doesn't report this section correctly
      current_word="${current_word:1}"
      current_line_length="${wrap_limit}"
      #:nocov:
    fi

    if (("$((current_line_length + current_word_length))" <= wrap_limit)); then
      current_line+="${current_word} "
      output+="${current_word} "
    else
      current_line="${current_word} "
      stdlib.string.pad.left_var "${1}" "current_word"
      output="${output%?}"
      output+="\n${current_word} "
    fi
  done

  echo -e "${output%?}"
}

stdlib.fn.derive.pipeable "stdlib.string.wrap" "3"
