#!/bin/bash

# stdlib testing mock main component

set -eo pipefail

export CONTENT

CONTENT="$(
  cat << EOF
${1}() {
  local _mock_object_args=()
  local _mock_object_pipe_input=""
  local _mock_object_rc=0
  local _mock_object_side_effects=()

  if [[ "\${__${2}_mock_pipeable}" -eq "1" ]]; then
    ${1}.mock.__controller pipeable
    set -- "\${@}" "\${_mock_object_pipe_input}"
  fi

  _mock_object_args=("\${@}")

  ${1}.mock.__controller call "\${_mock_object_args[@]}"

  ${1}.mock.__controller update_rc "\${__${2}_mock_rc}"
  ${1}.mock.__controller subcommand "\${_mock_object_args[@]}"
  ${1}.mock.__controller update_rc "\$?"
  ${1}.mock.__controller side_effects
  ${1}.mock.__controller update_rc "\$?"

  ${1}.mock.__controller stderr
  ${1}.mock.__controller stdout

  return "\${_mock_object_rc}"
}


${1}.mock.clear() {
  local _mock_object_side_effects=()
  echo -n "" > "\${__${2}_mock_calls_file}"
  declare -p _mock_object_side_effects > "\${__${2}_mock_side_effects_file}"
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
