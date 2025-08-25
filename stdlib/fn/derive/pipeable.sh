#!/bin/bash

# stdlib fn derive pipeable library

builtin set -eo pipefail

STDIN_SOURCE_SPECIFIER="${STDIN_SOURCE_SPECIFIER:-""}"

stdlib.fn.derive.pipeable() {
  # $1: the function name
  # $2: the number of arguments required
  #
  # _STDIN_SOURCE_SPECIFIER:  a reserved argument used to specify a stdin source

  local derive_target_fn_name
  local stdin_source_specifier="${STDIN_SOURCE_SPECIFIER:-"-"}"

  stdlib.fn.args.require "2" "0" "${@}" || return "$?"
  stdlib.fn.assert.is_fn "${1}" || return 126
  stdlib.string.assert.is_digit "${2}" || return 126

  derive_target_fn_name="${1}"

  builtin eval "$(
    # KCOV_EXCLUDE_BEGIN
    "${_STDLIB_BINARY_CAT}" << EOF

${derive_target_fn_name}_pipe() {
  # \${@ 0:-2} the args to use
  # \${@ -1} the optional input string to operate on
  # NOTE: the position of stdin can also be specified with the arg "-"

  # mutate_pipe_parser_strategy
  #   ARGS_SPECIFIED:   the already specified arguments are sufficient to call the function
  #   STDIN_POSITIONAL: the user specified that an argument is explicitly from stdin
  #   STDIN_ASSUMED:    there are not enough arguments and no known position for stdin, append stdin

  local mutate_examined_arg=""
  local mutate_examined_arg_index=0
  local mutate_pipe_input=""
  local mutate_pipe_input_index=0
  local mutate_pipe_input_line=''
  local mutate_pipe_parser_strategy="ARG_SPECIFIED"
  local mutate_received_args=("\$@")

  # Append stdin strategy
  if [[ "\${#@}" -lt "${2}" ]]; then
    mutate_pipe_parser_strategy="STDIN_ASSUMED"
    mutate_pipe_input_index="\$(("\${#@}" + 1))"
  fi

  # Replace placeholder stdin strategy
  if [[ "\${mutate_pipe_parser_strategy}" == "ARG_SPECIFIED" ]]; then
    for mutate_examined_arg in "\${@}"; do
      if [[ "\${mutate_examined_arg}" == "${stdin_source_specifier}" ]]; then
        mutate_pipe_parser_strategy="STDIN_POSITIONAL"
        mutate_pipe_input_index="\${mutate_examined_arg_index}"
        builtin break
      fi
      ((mutate_examined_arg_index+=1))
    done
  fi

  # Does the current strategy require stdin ?
  if [[ "\${mutate_pipe_parser_strategy}" != "ARG_SPECIFIED" ]]; then
    while IFS= builtin read -r mutate_pipe_input_line; do
      mutate_pipe_input+="\${mutate_pipe_input_line}"
      mutate_pipe_input+=$'\n'
    done
    mutate_pipe_input="\${mutate_pipe_input%?}"
    mutate_received_args[mutate_pipe_input_index]="\${mutate_pipe_input}"
  fi

  "${derive_target_fn_name}" "\${mutate_received_args[@]}"
}
EOF
  )"
  # KCOV_EXCLUDE_END
}
