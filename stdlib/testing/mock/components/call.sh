#!/bin/bash

# stdlib testing mock calls component

builtin set -eo pipefail

export CONTENT

CONTENT="$(
  "${_STDLIB_BINARY_CAT}" << EOF
${1}.mock.__call() {
  # $@: the arguments the mock was called with

  local _mock_object_args=("\${@}")
  local _mock_object_call_array=()

  __mock.arg_array.from_array \
    _mock_object_call_array \
    _mock_object_args \
    "__${2}_mock_keywords"

  builtin declare -p _mock_object_call_array >> "\${__${2}_mock_calls_file}"

  if [[ "\${__MOCK_SEQUENCE_TRACKING}" == "1" ]]; then
    __mock.persistence.sequence.retrieve
    __MOCK_SEQUENCE+=("${1}")
    __mock.persistence.sequence.update
  fi
}
EOF
)"
