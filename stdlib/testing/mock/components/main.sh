#!/bin/bash

# pictl testing mock main component

set -eo pipefail

export CONTENT

CONTENT="$(
  cat << EOF
${1}() {
  local MOCK_ARGS=()
  local MOCK_RC=0
  local MOCK_SIDE_EFFECTS=()
  local TEST_MOCK_PIPE_INPUT_LINE=""

  if [[ "\${__${2}_mock_pipeable}" -eq "1" ]]; then
    ${1}.mock.__controller pipeable
    set -- "\${@}" "\${TEST_MOCK_PIPE_INPUT}"
  fi

  MOCK_ARGS=("\${@}")

  ${1}.mock.__controller call "\${MOCK_ARGS[@]}"

  ${1}.mock.__controller update_rc "\${__${2}_mock_rc}"
  ${1}.mock.__controller subcommand "\${MOCK_ARGS[@]}"
  ${1}.mock.__controller update_rc "\$?"
  ${1}.mock.__controller side_effects
  ${1}.mock.__controller update_rc "\$?"

  ${1}.mock.__controller stderr
  ${1}.mock.__controller stdout

  return "\${MOCK_RC}"
}


${1}.mock.clear() {
  local MOCK_SIDE_EFFECTS=()
  echo -n "" > "\${__${2}_mock_calls_file}"
  declare -p MOCK_SIDE_EFFECTS > "\${__${2}_mock_side_effects_file}"
}

${1}.mock.reset() {
  ${1}.mock.clear
  __${2}_mock_rc=""
  __${2}_mock_stderr=""
  __${2}_mock_stdout=""
  unset -f __${1}_mock_subcommand || /bin/true
}
EOF
)"
