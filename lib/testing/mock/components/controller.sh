#!/bin/bash

# pictl testing mock controller component

set -eo pipefail

export CONTENT

CONTENT="$(
  cat << EOF
${1}.mock.__controller() {
  # $1: the mock component to execute
  # $@: additional arguments to pass

  local MOCK_SIDE_EFFECTS
  local TEST_MOCK_PIPE_INPUT_LINE
  local TEST_MOCK_SIDE_EFFECT

  case "\${1}" in
    call)
      declare -p MOCK_ARGS >> "\${__${2}_mock_calls_file}"
      __MOCK_SEQUENCE+=("${1}")
      ;;
    pipeable)
      while IFS= read -r TEST_MOCK_PIPE_INPUT_LINE; do
        TEST_MOCK_PIPE_INPUT+="\${TEST_MOCK_PIPE_INPUT_LINE}"
      done
      ;;
    side_effects)
      if [[ "\${__${2}_mock_side_effects_boolean}" == "1" ]]; then
        eval "\$(<"\${__${2}_mock_side_effects_file}")"
        if [[ "\${#MOCK_SIDE_EFFECTS[@]}" -gt 0 ]]; then
          TEST_MOCK_SIDE_EFFECT="\${MOCK_SIDE_EFFECTS[0]}"
          MOCK_SIDE_EFFECTS=("\${MOCK_SIDE_EFFECTS[@]:1}")
          declare -p MOCK_SIDE_EFFECTS > "\${__${2}_mock_side_effects_file}"
          eval "\${TEST_MOCK_SIDE_EFFECT}"
        fi
      fi
      ;;
    stderr)
      if [[ -n "\${__${2}_mock_stderr}" ]]; then
        echo "\${__${2}_mock_stderr}" >&2
      fi
      ;;
    stdout)
      if [[ -n "\${__${2}_mock_stdout}" ]]; then
        echo "\${__${2}_mock_stdout}"
      fi
      ;;
    subcommand)
      if declare -F __${1}_mock_subcommand > /dev/null 2>&1; then
        __${1}_mock_subcommand "\${@:2}"
      fi
      ;;
    update_rc)
      # if passed a valid return code, and we're not set to 0 then update to the newest code
      if [[ -n "\${2}" ]] && [[ "\${MOCK_RC}" == "0" ]]; then
        MOCK_RC="\${2}"
      fi
      ;;
  esac
}
EOF
)"
