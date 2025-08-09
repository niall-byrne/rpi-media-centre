#!/bin/bash

# pictl testing mock setter component

set -eo pipefail

export CONTENT

CONTENT="$(
  cat << EOF
${1}.mock.set.pipeable() {
  # $1: the boolean to enable or disable the pipeable attribute

  if (("\${1}" < "0" || "\${1}" > 1)); then
    _test_error "The 'pipeable' attribute may be either '0' or '1', received '\${1}'!"
  fi

  printf -v "__${2}_mock_pipeable" "%s" "\${1}"
}

${1}.mock.set.rc() {
  # $1: the return code to make the mock return

  printf -v "__${2}_mock_rc" "%s" "\${1}"
}

${1}.mock.set.side_effects() {
  # $1: the array to set as a queue of side effect functions

  local MOCK_SIDE_EFFECTS

  MOCK_SIDE_EFFECTS=("\${@}")
  declare -p MOCK_SIDE_EFFECTS > "\${__${2}_mock_side_effects_file}"
  printf -v "__${2}_mock_side_effects_boolean" "%s" "1"
}

${1}.mock.set.stderr() {
  # $1: the value to make the mock emit to stderr

  printf -v "__${2}_mock_stderr" "%s" "\${1}"
}

${1}.mock.set.stdout() {
  # $1: the value to make the mock emit to stdout

  printf -v "__${2}_mock_stdout" "%s" "\${1}"
}

${1}.mock.set.subcommand() {
  # $@: the subcommand to execute on each mock call

  eval "__${1}_mock_subcommand() {
      \${@}
  }"
}
EOF
)"
