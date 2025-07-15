#!/bin/bash

# pictl io library

set -eo pipefail

_io_append_newline_stdin() {
  local FILE_LINE

  echo ""
  while IFS= read -r FILE_LINE; do
    echo "${FILE_LINE}"
  done
}

_io_colours_escape() {

  local RPI_IO_COLOUR_LIST
  local RPI_IO_COLOUR

  _io_colours_load "1"
  _io_colours_load_theme

  RPI_IO_COLOUR_LIST="$(
    declare -p |
      grep '^declare -. COLOUR_\|^declare -. THEME_' |
      sed 's/^declare -. //g' |
      cut -d '=' -f 1
  )"

  for RPI_IO_COLOUR in ${RPI_IO_COLOUR_LIST}; do
    printf -v "${RPI_IO_COLOUR}" '%s' "\${${RPI_IO_COLOUR}}"
  done
}

_io_colours_load() {
  # $1: override to force loading regardless of config

  local RPI_IO_COLOUR_FORCE_BOOLEAN="${1}"
  local RPI_IO_COLOUR_LIST
  local RPI_IO_COLOUR

  if [[ "${RPI_COLOUR_BOOLEAN}" == "1" ]] ||
    [[ "${RPI_IO_COLOUR_FORCE_BOOLEAN}" == "1" ]]; then
    tput init >> /dev/null 2>&1 || return 0

    source "${RPI_WORKING_DIRECTORY}/lib/cli/theme/base_colours.sh"

    RPI_IO_COLOUR_LIST="$(
      declare -p |
        grep '^declare -. RPI_COLOUR_' |
        sed 's/^declare -. //g' |
        cut -d '=' -f 1
    )"

    for RPI_IO_COLOUR in ${RPI_IO_COLOUR_LIST}; do
      printf -v "${RPI_IO_COLOUR/RPI_/}" '%s' "${!RPI_IO_COLOUR}"
    done

    _io_colours_load_theme
  fi
}

_io_colours_load_theme() {
  # shellcheck source=/dev/null
  source "${RPI_WORKING_DIRECTORY}/lib/cli/theme/${RPI_COLOUR_THEME}.sh"
  # shellcheck disable=SC2034
  THEME_NC="${COLOUR_NC}"
}

_io_comment_lines_stdin() {
  local FILE_LINE

  while IFS= read -r FILE_LINE; do
    echo "# ${FILE_LINE}"
  done
}

_io_make_pipeable() {
  # $1: the function name
  # $2: the number of arguments expected

  local RPI_IO_FUNCTION_NAME
  local RPI_IO_ORIGINAL_FUNCTION_REFERENCE
  local RPI_IO_STDIN_SOURCE="-"

  RPI_IO_FUNCTION_NAME="${1}"
  RPI_IO_ORIGINAL_FUNCTION_REFERENCE="${RPI_IO_FUNCTION_NAME}_original_function_definition"

  declare -f \
    "${RPI_IO_FUNCTION_NAME}" > /dev/null ||
    {
      echo "The function '${RPI_IO_ORIGINAL_FUNCTION_REFERENCE}' doesn't appear to exist!"
      return 127
    }

  eval "$(
    echo "${RPI_IO_ORIGINAL_FUNCTION_REFERENCE}()"
    declare -f "${RPI_IO_FUNCTION_NAME}" | tail -n +2
  )"

  eval "$(
    cat << EOF

${RPI_IO_FUNCTION_NAME}() {
  # \${@ 0:-2} the args to use
  # \${@ -1} the optional input string to operate on

  # RPI_IO_PIPE_INPUT_PARSER
  #   ARGS_SPECIFIED:  the already specified arguments are sufficient to call the function
  #   STDIN_SPECIFIED: the user specified that the argument is explicitly from stdin
  #   STDIN_ASSUMED:   there are not enough arguments, supplement with stdin

  local RPI_IO_LAST_ARGUMENT="\${!#}"
  local RPI_IO_PIPE_INPUT_LINE
  local RPI_IO_PIPE_INPUT=$'\n'
  local RPI_IO_PIPE_INPUT_PARSER="ARG_SPECIFIED"

  if [[ "\${1}" == "${RPI_IO_STDIN_SOURCE}" ]]; then
    RPI_IO_PIPE_INPUT_PARSER="STDIN_SPECIFIED"
  elif [[ "\${#@}" -lt "${2}" ]]; then
    RPI_IO_PIPE_INPUT_PARSER="STDIN_ASSUMED"
  fi

  if [[ "\${RPI_IO_PIPE_INPUT_PARSER}" != "ARG_SPECIFIED" ]]; then
    while IFS= read -r RPI_IO_PIPE_INPUT_LINE; do
      RPI_IO_PIPE_INPUT+="\${RPI_IO_PIPE_INPUT_LINE}"$'\n'
    done
  fi

  case "\${RPI_IO_PIPE_INPUT_PARSER}" in
    "ARG_SPECIFIED")
      "${RPI_IO_ORIGINAL_FUNCTION_REFERENCE}" "\$@"
      ;;
    "STDIN_SPECIFIED")
      "${RPI_IO_ORIGINAL_FUNCTION_REFERENCE}" "\${RPI_IO_PIPE_INPUT:1:-1}" "\${@:2}"
      ;;
    "STDIN_ASSUMED")
      "${RPI_IO_ORIGINAL_FUNCTION_REFERENCE}" "\$@" "\${RPI_IO_PIPE_INPUT:1:-1}"
      ;;
  esac
}
EOF
  )"

}

_io_make_var_function() {
  # $1: the function name
  # $2: (optional) the new function name

  local RPI_IO_VAR_FUNCTION_NAME

  RPI_IO_VAR_FUNCTION_NAME="${2:-"${1}_var"}"

  eval "$(
    cat << EOF

${RPI_IO_VAR_FUNCTION_NAME}() {
  # \${@ 0:-2} the args to use
  # \${@ -1} the variable name to apply the function to

  local RPI_IO_LAST_ARGUMENT="\${!#}"

  if [[ "\${#@}" -eq "1" ]]; then
    if [[ -z "\${!RPI_IO_LAST_ARGUMENT}" ]]; then
      printf -v "\${RPI_IO_LAST_ARGUMENT}" "%s" ""
    else
      printf -v "\${RPI_IO_LAST_ARGUMENT}" "%s" "\$("${1}" "\${!RPI_IO_LAST_ARGUMENT}")"
    fi
  else
    printf -v "\${RPI_IO_LAST_ARGUMENT}" "%s" "\$("${1}" "\${@:1:\$#-1}" "\${!RPI_IO_LAST_ARGUMENT}")"
  fi
}

EOF
  )"
}

_io_prompt() {
  # 1: the prompt to display
  # 2: the variable name to save
  # 3: optionally set to "password" to suppress output

  local FLAGS="-rp"

  if [[ "${3}" == "password" ]]; then
    FLAGS="-rsp"
  fi

  while [[ -z "${!2}" ]]; do
    # shellcheck disable=SC2229,SC2162
    read "${FLAGS}" "$1" "$2"
    if [[ "${3}" == "password" ]]; then
      echo
    fi
  done
}

_io_prompt_confirmation() {

  local RPI_IO_CONFIRMATION

  echo -n "Are you sure you wish to proceed (Y/n) ? "

  while true; do
    read -rs -n 1 RPI_IO_CONFIRMATION
    if [[ "${RPI_IO_CONFIRMATION}" == "n" ]]; then
      echo ""
      return 127
    fi
    if [[ "${RPI_IO_CONFIRMATION}" == "Y" ]]; then
      echo ""
      return 0
    fi
  done
}
