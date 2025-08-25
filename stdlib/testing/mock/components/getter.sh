#!/bin/bash

# stdlib testing mock getter component

builtin set -eo pipefail

export CONTENT

CONTENT="$(
  "${_STDLIB_BINARY_CAT}" << EOF
${1}.mock.__get_apply_to_matching_mock_calls() {
  # $1: the matching command to execute against mock_args (# noqa)
  # $@: the command to apply to the result (# noqa)

  local _mock_object_call_file_index=1
  local _mock_object_call_file_line

  while builtin read -r _mock_object_call_file_line; do
    builtin eval "\${_mock_object_call_file_line}"
    builtin printf -v _mock_object_escaped_args "%q" "\${_mock_object_call_array[*]}"
    if builtin eval "\${1}"; then
      builtin eval "\${@:2}"
    fi
    ((_mock_object_call_file_index++))
  done < "\${__${2}_mock_calls_file}"
}

${1}.mock.get.call() {
  # $1: the call to retrieve

  local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  local _mock_object_escaped_args

  __testing.protected stdlib.fn.args.require "1" "0" "\${@}" || return "\$?"
  __testing.protected stdlib.string.assert.is_digit "\${1}" || return 126
  __testing.protected stdlib.string.assert.not_equal "0" "\${1}" || return 126

  builtin printf -v _mock_object_escaped_args "%q" "\${1}"

  ${1}.mock.__get_apply_to_matching_mock_calls \
    "[[ "\\\${_mock_object_call_file_index}" == "\${_mock_object_escaped_args}" ]]" \
    builtin printf '%s\\\\n' '"\${_mock_object_call_array[*]}"'
}

${1}.mock.get.calls() {
  local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  local _mock_object_escaped_args

  __testing.protected stdlib.fn.args.require "0" "0" "\${@}" || return "\$?"

  ${1}.mock.__get_apply_to_matching_mock_calls \
    "true" \
    builtin printf '%s\\\\n' '"\${_mock_object_call_array[*]}"'
}

${1}.mock.get.count() {
  local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  __testing.protected stdlib.fn.args.require "0" "0" "\${@}" || return "\$?"

  < "\${__${2}_mock_calls_file}" wc -l
}

${1}.mock.get.keywords() {
  local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  __testing.protected stdlib.fn.args.require "0" "0" "\${@}" || return "\$?"

  builtin echo "\${__${2}_mock_keywords[*]}"
}
EOF
)"
