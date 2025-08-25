#!/bin/bash

# stdlib testing mock setter component

builtin set -eo pipefail

export CONTENT

CONTENT="$(
  "${_STDLIB_BINARY_CAT}" << EOF
${1}.mock.set.keywords() {
  # $@: the keyword names to assign to the mock

  local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  local _mock_object_keywords=("\${@}")

  __testing.protected stdlib.array.assert.not_contains "" _mock_object_keywords || return 126

  builtin eval "__${2}_mock_keywords=(\$(builtin printf '%q ' "\${@}"))"
}


${1}.mock.set.pipeable() {
  # $1: the boolean to enable or disable the pipeable attribute

  local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  __testing.protected stdlib.fn.args.require "1" "0" "\${@}" || return "\$?"
  __testing.protected stdlib.string.assert.is_boolean "\${1}" || return 126

  builtin printf -v "__${2}_mock_pipeable" "%s" "\${1}"
}

${1}.mock.set.rc() {
  # $1: the return code to make the mock return

  local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  __testing.protected stdlib.fn.args.require "1" "0" "\${@}" || return "\$?"
  __testing.protected stdlib.string.assert.is_integer_with_range "0" "255" "\${1}" || return 126

  builtin printf -v "__${2}_mock_rc" "%s" "\${1}"
}

${1}.mock.set.side_effects() {
  # $1: the array to set as a queue of side effect functions

  local _mock_object_side_effects=("\${@}")

  builtin declare -p _mock_object_side_effects > "\${__${2}_mock_side_effects_file}"
  builtin printf -v "__${2}_mock_side_effects_boolean" "%s" "1"
}

${1}.mock.set.stderr() {
  # $1: the value to make the mock emit to stderr

  local _STDLIB_ARGS_NULL_SAFE=("1")
  local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  __testing.protected stdlib.fn.args.require "1" "0" "\${@}" || return "\$?"

  builtin printf -v "__${2}_mock_stderr" "%s" "\${1}"
}

${1}.mock.set.stdout() {
  # $1: the value to make the mock emit to stdout

  local _STDLIB_ARGS_NULL_SAFE=("1")
  local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  __testing.protected stdlib.fn.args.require "1" "0" "\${@}" || return "\$?"

  builtin printf -v "__${2}_mock_stdout" "%s" "\${1}"
}

${1}.mock.set.subcommand() {
  # $@: the subcommand to execute on each mock call

  builtin eval "__${1}_mock_subcommand() {
      \${@}
  }"
}
EOF
)"
