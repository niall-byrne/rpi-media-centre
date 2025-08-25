#!/bin/bash

# stdlib string wrap library

builtin set -eo pipefail

_STDLIB_LINE_BREAK_CHAR=""
_STDLIB_WRAP_PREFIX_STRING=""

stdlib.string.wrap() {
  # $1: the left-side padding
  # $2: the right-side wrap limit
  # $3: the text to wrap
  #
  # _STDLIB_LINE_BREAK_CHAR:     a char that forces a line break in the text (# noqa)
  # _STDLIB_WRAP_PREFIX_STRING:  a string to insert when wrapping text

  local _STDLIB_ARGS_NULL_SAFE=("3")
  local wrap_indent_string="${_STDLIB_WRAP_PREFIX_STRING:-""}"
  local forced_line_break_char="${_STDLIB_LINE_BREAK_CHAR:-*}"

  local current_line=""
  local current_line_length=0
  local current_word=""
  local current_word_length=0
  local input_array=()
  local output=""
  local wrap_limit=0
  local wrap_indent_length="${#wrap_indent_string}"

  stdlib.fn.args.require "3" "0" "${@}" || return "$?"
  stdlib.string.assert.is_digit "${1}" || return 126
  stdlib.string.assert.is_digit "${2}" || return 126

  wrap_limit="$(("${2}" - "${1}"))"
  builtin read -ra input_array <<< "${3}"

  for current_word in "${input_array[@]}"; do
    current_line_length="${#current_line}"
    current_word_length="${#current_word}"

    if stdlib.string.query.first_char_is "${forced_line_break_char}" "${current_word}"; then
      current_word="${current_word:1}"
      current_line_length="${wrap_limit}"
    fi

    if (("$((current_line_length + current_word_length + wrap_indent_length))" <= wrap_limit)); then
      current_line+="${current_word} "
      output+="${current_word} "
    else
      current_line="${current_word} "
      current_word="${wrap_indent_string}${current_word}"
      stdlib.string.pad.left_var "${1}" "current_word"
      output="${output%?}"
      output+="\n${current_word} "
    fi
  done

  builtin echo -e "${output%?}"
}

stdlib.fn.derive.pipeable "stdlib.string.wrap" "3"
