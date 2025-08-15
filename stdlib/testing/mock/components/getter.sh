#!/bin/bash

# stdlib testing mock getter component

set -eo pipefail

export CONTENT

CONTENT="$(
  cat << EOF
${1}.mock.__get_apply_to_matching_mock_calls() {
  # $1: the matching command to execute against mock_args
  # $@: the command to apply to the result

  local _mock_object_call_file_index=1
  local _mock_object_call_file_line

  while read -r _mock_object_call_file_line; do
    eval "\${_mock_object_call_file_line}"
    printf -v _mock_object_escaped_args "%q" "\${_mock_object_args[*]}"
    if eval "\${1}"; then
      eval "\${@:2}"
    fi
    ((_mock_object_call_file_index++))
  done < "\${__${2}_mock_calls_file}"
}

${1}.mock.get.call() {
  # $1: the call to retrieve

  local _mock_object_escaped_args

  printf -v _mock_object_escaped_args "%q" "\${1}"

  ${1}.mock.__get_apply_to_matching_mock_calls \
    "[[ "\\\${_mock_object_call_file_index}" == "\${_mock_object_escaped_args}" ]]" \
    printf '%s\\\\n' '"\${_mock_object_args[*]}"'
}

${1}.mock.get.calls() {
  # $1: the call to retrieve

  local _mock_object_escaped_args

  ${1}.mock.__get_apply_to_matching_mock_calls \
    "/bin/true" \
    printf '%s\\\\n' '"\${_mock_object_args[*]}"'
}

${1}.mock.get.count() {
  < "\${__${2}_mock_calls_file}" wc -l
}
EOF
)"
