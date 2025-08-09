#!/bin/bash

# pictl testing mock getter component

set -eo pipefail

export CONTENT

CONTENT="$(
  cat << EOF
${1}.mock.__get_apply_to_matching_mock_calls() {
  # $1: the matching command to execute against MOCK_ARGS
  # $@: the command to apply to the result

  local TEST_MOCK_FILE_LINE
  local TEST_MOCK_FILE_INDEX=1
  local TEST_ESCAPED_MOCK_ARGS

  while read -r TEST_MOCK_FILE_LINE; do
    eval "\${TEST_MOCK_FILE_LINE}"
    printf -v TEST_ESCAPED_MOCK_ARGS "%q" "\${MOCK_ARGS[*]}"
    if eval "\${1}"; then
      eval "\${@:2}"
    fi
    ((TEST_MOCK_FILE_INDEX++))
  done < "\${__${2}_mock_calls_file}"
}

${1}.mock.get.call() {
  # $1: the call to retrieve

  local TEST_ESCAPED_ARG

  printf -v TEST_ESCAPED_ARG "%q" "\${1}"

  ${1}.mock.__get_apply_to_matching_mock_calls \
    "[[ "\\\${TEST_MOCK_FILE_INDEX}" == "\${TEST_ESCAPED_ARG}" ]]" \
    printf '%s\\\\n' '"\${MOCK_ARGS[*]}"'
}

${1}.mock.get.calls() {
  # $1: the call to retrieve

  ${1}.mock.__get_apply_to_matching_mock_calls \
    "/bin/true" \
    printf '%s\\\\n' '"\${MOCK_ARGS[*]}"'
}

${1}.mock.get.count() {
  < "\${__${2}_mock_calls_file}" wc -l
}
EOF
)"
